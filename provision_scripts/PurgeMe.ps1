param (
    [string]$CloneServerUrl = 'http://ec2amaz-hduull0:14145', 
    [string]$MachineName = 'EC2AMAZ-HDUULL0',
    [string]$InstanceName = ''
)

Connect-SqlClone -ServerUrl $CloneServerUrl
$SqlServerInstance = Get-SqlCloneSqlServerInstance -MachineName $MachineName -InstanceName $InstanceName

$adCloneToDelete = Get-SqlClone -Name 'AdventureWorks2017' -Location $SqlServerInstance
$soCloneToDelete = Get-SqlClone -Name 'StackOverflow2010' -Location $SqlServerInstance

Write-Output "Purging clones"

Remove-SqlClone -Clone $adCloneToDelete
Remove-SqlClone -Clone $soCloneToDelete

Write-Output "All gone"
