param (
    [string]$cloneServerUrl = 'http://ec2amaz-hduull0:14145', 
    [string]$machineName = 'EC2AMAZ-HDUULL0',
    [string]$instanceName = ''
)

Connect-SqlClone -ServerUrl $CloneServerUrl
$sqlServerInstance = Get-SqlCloneSqlServerInstance -MachineName $machineName -InstanceName $instanceName

$cloneToDelete = Get-SqlClone -Name 'StackOverflow2010' -Location $sqlServerInstance

Write-Output "Purging clones"

Remove-SqlClone -Clone $cloneToDelete | Wait-SqlCloneOperation

Write-Output "All gone"
