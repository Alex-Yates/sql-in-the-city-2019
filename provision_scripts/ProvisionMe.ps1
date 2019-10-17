param (
    [string]$CloneServerUrl = 'http://ec2amaz-hduull0:14145', 
    [string]$MachineName = 'EC2AMAZ-HDUULL0',
    [string]$InstanceName = ''
)

Connect-SqlClone -ServerUrl $CloneServerUrl
$adImage = Get-SqlCloneImage -Name 'AdventureWorks'
$soImage = Get-SqlCloneImage -Name 'StackOverflow'
$SqlServerInstance = Get-SqlCloneSqlServerInstance -MachineName $MachineName -InstanceName $InstanceName

Write-Output "Building clones"

New-SqlClone -Name 'AdventureWorks2017' -Location $SqlServerInstance -Image $adImage
New-SqlClone -Name 'StackOverflow2010' -Location $SqlServerInstance -Image $soImage

Write-Output "Cloning complete"
