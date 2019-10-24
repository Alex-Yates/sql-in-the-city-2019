param (
    [string]$cloneServerUrl = 'http://ec2amaz-hduull0:14145', 
    [string]$machineName = 'EC2AMAZ-HDUULL0',
    [string]$instanceName = ''
)

Connect-SqlClone -ServerUrl $cloneServerUrl
$image = Get-SqlCloneImage -Name 'StackOverflow2010'
$sqlServerInstance = Get-SqlCloneSqlServerInstance -MachineName $machineName -InstanceName $instanceName

Write-Output "Building clone"

New-SqlClone -Name 'StackOverflow2010' -Location $sqlServerInstance -Image $image  | Wait-SqlCloneOperation

Write-Output "Cloning complete"
