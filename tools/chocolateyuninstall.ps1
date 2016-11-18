$ErrorActionPreference = 'Stop';


$packageName = 'splunkforwarder'
$registryUninstallerKeyName = '{D23A0D86-94B2-4BFA-9703-4C403A602C33}' 
# ensure this is the value in the registry or check with the following wmi command
# get-wmiobject Win32_Product | where-object {$_.name -eq "UniversalForwarder"} | select identifyingNumber
$installerType = 'MSI'
$silentArgs = "$registryUninstallerKeyname /quiet"
$validExitCodes = @(0)

Uninstall-ChocolateyPackage -PackageName $packageName -FileType $installerType -SilentArgs $silentArgs -validExitCodes $validExitCodes -File $registryUninstallerKeyName