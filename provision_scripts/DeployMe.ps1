# Declare the full path of the SCA project files
$awProjectFile="${PSScriptRoot}\..\databases\AdventureWorks\AdventureWorks.sqlproj"
$soProjectFile="${PSScriptRoot}\..\databases\StackOverflow\StackOverflow.sqlproj"

# Create the database build artifact object required to deploy the update to the dev database
# (I don't need to 'build' a database as I'm not concerned with validation so use New-DatabaseProjectObject instead of Invoke-DatbaesBuild)
$awBuildArtifact  = $awProjectFile | New-DatabaseProjectObject | New-DatabaseBuildArtifact -PackageId AdventureWorks -PackageVersion 0.0.1
$soBuildArtifact  = $soProjectFile | New-DatabaseProjectObject | New-DatabaseBuildArtifact -PackageId StackOverflow -PackageVersion 0.0.1

# Defining the target dev databases
$awTarget = New-DatabaseConnection -ServerInstance "." -Database AdventureWorks2017
$soTarget = New-DatabaseConnection -ServerInstance "." -Database StackOverflow2010

# Create the deployment artifacts targeting the dev databases to be updated
$awReleaseArtifact  = New-DatabaseReleaseArtifact -Source $awBuildArtifact -Target $awTarget
$soReleaseArtifact  = New-DatabaseReleaseArtifact -Source $soBuildArtifact -Target $soTarget

# Deploy to the dev databases
Use-DatabaseReleaseArtifact $awReleaseArtifact -DeployTo $awTarget -DisableMonitorAnnotation -SkipPreUpdateSchemaCheck -SkipPostUpdateSchemaCheck
Use-DatabaseReleaseArtifact $soReleaseArtifact -DeployTo $soTarget -DisableMonitorAnnotation -SkipPreUpdateSchemaCheck -SkipPostUpdateSchemaCheck


