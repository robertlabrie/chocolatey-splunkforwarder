$ErrorActionPreference = 'Stop';


$packageName = 'splunkforwarder'
$registryUninstallerKeyName = '{ADCAD08D-92F7-42BB-956E-D558F8FFBF14}' #ensure this is the value in the registry
$installerType = 'MSI'
$silentArgs = "$registryUninstallerKeyname /quiet"
$validExitCodes = @(0)

Uninstall-ChocolateyPackage -PackageName $packageName -FileType $installerType -SilentArgs $silentArgs -validExitCodes $validExitCodes -File $registryUninstallerKeyName