function Get-UninstallHash
{
    Param($package)

    $regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"
    Get-ChildItem -Path $regPath | ForEach-Object { if ((Get-ItemProperty "$regPath\$($_.PSChildName)").DisplayName -eq $package) { return $_.PSChildName } }

    if (Test-Path "HKLM:\SOFTWARE\Wow6432Node\") {
        $regPath = "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall"
        Get-ChildItem -Path $regPath | ForEach-Object { if ((Get-ItemProperty "$regPath\$($_.PSChildName)").DisplayName -eq $package) { return $_.PSChildName } }
    }
    #return $false
}

$ErrorActionPreference = 'Stop';

$hash = (Get-UninstallHash -package "UniversalForwarder")
Write-Output "uninstalling hash: |$hash|"

$packageName = 'splunkforwarder'
$registryUninstallerKeyName = $hash #ensure this is the value in the registry
$installerType = 'MSI'
$silentArgs = "$registryUninstallerKeyname /quiet"
$validExitCodes = @(0)

Uninstall-ChocolateyPackage -PackageName $packageName -FileType $installerType -SilentArgs $silentArgs -validExitCodes $validExitCodes -File $registryUninstallerKeyName