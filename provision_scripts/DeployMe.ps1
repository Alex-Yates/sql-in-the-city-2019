<#

INCOMPLETE

The following script was provided David Atkinson and still needs to be updated for my purposes.

To do:
1. Delete all the stuff to do with branching
2. Keep the stuff that deploys SCA projects
3. Reconfigure to deploy my StackOverflow and AdventureWorks projects
   (Possibly extract into a function)
4. Parameterize to make it re-usable, but add defaults for simple demos

#>

# If a branch is supplied, the script will switch to, or create a branch before provisioning
# Otherwise, provisioning will apply to the current branch
param($branchName="")

##########################################################################################
# Configure Clone Server, image and SQL Server instance
$CloneServerUrl = "http://pdm-david:14145"
$ImageName = "SimpleTalk" # SQL Clone image from which dev database clones will be created

# SQL Server machine hosting the clone database (must have Clone Agent installed):
$SqlServerMachineName = "PDM-DAVID"
$SqlServerInstanceName = "SQL2016" # Use empty string for the default instance

# This script currently assumes Windows Auth will be used to connect to the database clone
##########################################################################################
# Credits: Chris Hurley (the bits that work) & David A (the rest)
##########################################################################################

$StopWatch = New-Object -TypeName System.Diagnostics.Stopwatch 
$StopWatch.Start()

# Find the full path of the SCA project file
#$ProjectFile=Get-ChildItem -Path ${PSScriptRoot}\* -Include *.sqlproj
$ProjectFile=Get-ChildItem -Path "${PSScriptRoot}\..\*" -Include *.sqlproj -Recurse
Write-Host "ProjectFile identified:$ProjectFile"

# Based on supplied $branchName parameter, decide whether to provision clone in an existing branch or in a newly created branch
if ($branchName -ne "") {
    Write-Host "Branch parameter supplied: $branchName"
    git show-ref --verify --quiet refs/heads/${branchName}
    if ($lastexitcode -eq 0) {
        Write-Host "Branch exists already, so switching to $branchName"
        git checkout ${branchName}
    }
    else {
        Write-Host "Branch does not exist, so creating: $branchName"
        git checkout -b ${branchName}
    }
}
else { # If no branch specified, find the current branch name
    if ($null -ne (Get-Command "git" -ErrorAction SilentlyContinue)) {
        $rawBranchName = Invoke-Expression "git rev-parse --abbrev-ref HEAD" 2>&1
        if ($lastexitcode -eq 0) {
         $branchName = "$($rawBranchName | ForEach-Object {$_ -replace "\W"})"
         Write-Host "No branch specified - current branch identified as: ${branchName}"
        }
    }   
}

# Use username and git branch (if available) to uniquify database name
$username = $env:UserName

# Connect to Clone Server and obtain resources
Connect-SqlClone $CloneServerUrl -ErrorAction Stop
$image = Get-SqlCloneImage $ImageName -ErrorAction Stop
Write-Host "Found SQL Clone image $ImageName"

$sqlServerInstance = Get-SqlCloneSqlServerInstance -MachineName $SqlServerMachineName -InstanceName $SqlServerInstanceName -ErrorAction Stop
Write-Host "Found SQL Server instance ${SqlServerInstanceName}\${$SqlServerInstanceName}"

# Check if a clone already exists
$cloneName = "${ImageName}_${branchname}_${username}"
if ($null -ne (Get-SqlClone -Name $cloneName -Location $sqlServerInstance -ErrorAction SilentlyContinue)) {
    Get-SqlClone -Name $cloneName -Location $sqlServerInstance
    Write-Host "Database clone already exists: $cloneName"
} else {
    Write-Host "Creating new clone $cloneName"
    New-SqlClone -Name $cloneName -Image $image -Location $sqlServerInstance -ErrorAction Stop | Wait-SqlCloneOperation -ErrorAction Stop

    # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
    Write-Host "Now we migrate the new clone to the version represented in the branch" 

    # Create the database build artifact object required to deploy the update to the dev database
    # (I don't need to 'build' a database as I'm not concerned with validation so use New-DatabaseProjectObject instead of Invoke-DatbaesBuild)
    $dbBuildArtifact  = $ProjectFile | New-DatabaseProjectObject | New-DatabaseBuildArtifact -PackageId MyDatabase -PackageVersion 1.0.0

    # Create the deployment artifact targeting the dev databaseto be updated
    $devtarget = New-DatabaseConnection -ServerInstance "${SqlServerMachineName}\${SqlServerInstanceName}" -Database ${cloneName}
    $releaseArtifact  = New-DatabaseReleaseArtifact -Source $dbBuildArtifact -Target $devtarget
    
    # Deploy to the dev database
    Use-DatabaseReleaseArtifact $releaseArtifact -DeployTo $devtarget -DisableMonitorAnnotation -SkipPreUpdateSchemaCheck -SkipPostUpdateSchemaCheck
}

# Create or update the SQL Change Automation .sqlproj.user file, where the linked dev database is stored
# We also modify the name of the Shadow database to prevent it duplicating the username, which would otherwise appear twice
$projectUserFile = "${ProjectFile}.user"
$connectionString = "Data Source=${SqlServerMachineName}\${SqlServerInstanceName};Initial Catalog=${cloneName};Integrated Security=True"
$connectionStringShadow = "Data Source=${SqlServerMachineName}\${SqlServerInstanceName};Initial Catalog=${ImageName}_${branchname}_SHADOW_${username};Integrated Security=True"
$msbuildNs = "http://schemas.microsoft.com/developer/msbuild/2003"

if (Test-Path $projectUserFile) {
    Write-Host "Updating SCA project user file $projectUserFile"
    [xml]$xmlProjectUserDoc = Get-Content $projectUserFile
    $nsMgr = New-Object System.Xml.XmlNamespaceManager($xmlProjectUserDoc.NameTable)
    $nsMgr.AddNamespace("b", $msbuildNs)
    $targetConnectionString = $xmlProjectUserDoc.DocumentElement.SelectSingleNode("//b:TargetConnectionString", $nsMgr)
    Write-Host "Checking targetConnectionString:$targetConnectionString"
    $targetConnectionString.InnerText = $connectionString

     # Create the ShadowConnectionString element if it doesn't already exist
    $shadowConnectionString = $xmlProjectUserDoc.DocumentElement.SelectSingleNode("//b:ShadowConnectionString", $nsMgr) 
    if ($null -eq $shadowConnectionString) {
        $shadowConnectionString = $xmlProjectUserDoc.CreateElement("ShadowConnectionString", $msbuildNs)
        $propertyGroup = $xmlProjectUserDoc.DocumentElement.SelectSingleNode("//b:PropertyGroup", $nsMgr)
        $propertyGroup.AppendChild($shadowConnectionString)
    }
    $shadowConnectionString.InnerText = $connectionStringShadow

    $targetDatabase = $xmlProjectUserDoc.DocumentElement.SelectSingleNode("//b:TargetDatabase", $nsMgr)
    $targetDatabase.InnerText = $cloneName

    $xmlProjectUserDoc.Save($projectUserFile)
} else {
    Write-Host "Creating a new SCA project user file $projectUserFile"
    [xml]$xmlProjectUserDoc = New-Object System.Xml.XmlDocument
    $xmlDecl = $xmlProjectUserDoc.CreateXmlDeclaration("1.0","utf-8",$null)
    $xmlProjectUserDoc.AppendChild($xmlDecl) | Out-Null

    $projectNode = $xmlProjectUserDoc.CreateElement("Project", $msbuildNs)
    $toolsVersion = $xmlProjectUserDoc.CreateAttribute("ToolsVersion")
    $toolsVersion.Value = "15.0" 
    $projectNode.Attributes.Append($toolsVersion) | Out-Null

    $propertyGroup = $xmlProjectUserDoc.CreateElement("PropertyGroup", $msbuildNs)
    
    # Set the shadow so it has a sensible name (otherwise the username figures twice)
    $shadowConnectionString = $xmlProjectUserDoc.CreateElement("ShadowConnectionString", $msbuildNs)
    $shadowConnectionString.InnerText = $connectionStringShadow
    
    $targetConnectionString = $xmlProjectUserDoc.CreateElement("TargetConnectionString", $msbuildNs)
    $targetConnectionString.InnerText = $connectionString

    $targetDatabase = $xmlProjectUserDoc.CreateElement("TargetDatabase", $msbuildNs)
    $targetDatabase.InnerText = $cloneName

    $xmlProjectUserDoc.AppendChild($projectNode)  | Out-Null
    $projectNode.AppendChild($propertyGroup)  | Out-Null
    $propertyGroup.AppendChild($targetConnectionString)  | Out-Null
    $propertyGroup.AppendChild($shadowConnectionString)  | Out-Null
    $propertyGroup.AppendChild($targetDatabase) | Out-Null

    $xmlProjectUserDoc.Save($projectUserFile) | Out-Null
}

$StopWatch.Stop()
$provisionTime = $StopWatch.Elapsed.ToString('ss')
Write-Host "SCA provision completed in ${provisionTime} seconds" -ForegroundColor Green
