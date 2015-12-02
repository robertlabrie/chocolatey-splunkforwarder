function Get-UninstallHash
{
    Param($package)

    $regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"
    Get-ChildItem -Path $regPath | ForEach-Object { if ((Get-ItemProperty "$regPath\$($_.PSChildName)").DisplayName -eq $package) { return $_.PSChildName } }

    if (Test-Path "HKLM:\SOFTWARE\Wow6432Node\") {
        $regPath = "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall"
        Get-ChildItem -Path $regPath | ForEach-Object { if ((Get-ItemProperty "$regPath\$($_.PSChildName)").DisplayName -eq $package) { return $_.PSChildName } }
    }
    return $false
}

$ErrorActionPreference = 'Stop';


$packageName = 'splunkforwarder'
$registryUninstallerKeyName = 'splunkforwarder' #ensure this is the value in the registry
$installerType = 'MSI'
$url = 'http://download.splunk.com/products/splunk/releases/6.3.1/universalforwarder/windows/splunkforwarder-6.3.1-f3e41e4b37b2-x86-release.msi'
$url64 = 'http://download.splunk.com/products/splunk/releases/6.3.1/universalforwarder/windows/splunkforwarder-6.3.1-f3e41e4b37b2-x64-release.msi'
$silentArgs = '/quiet' # "/s /S /q /Q /quiet /silent /SILENT /VERYSILENT" # try any of these to get the silent installer #msi is always /quiet
$validExitCodes = @(0)
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

#Install-ChocolateyPackage "$packageName" "$installerType" "$silentArgs" "$url" ["$url64"  -validExitCodes $validExitCodes -checksum $checksum -checksumType $checksumType -checksum64 $checksum64 -checksumType64 $checksumType64]
$packageParameters = $env:chocolateyPackageParameters;

if (!($packageParameters -like "*RECEIVING_INDEXER*") -and !($packageParameters -like "*DEPLOYMENT_SERVER*"))
{
	Write-Warning "Did not specify RECEIVING_INDEXER or DEPLOYMENT_SERVER. It's a good idea to set one of these. Refer to the documentation"
}
Write-Output "Installing with  $packageParameters AGREETOLICENSE=Yes $silentArgs"

if (Get-UninstallHash -package "UniversalForwarder") { & "$toolsDir\chocolateyUninstall.ps1" }

Install-ChocolateyPackage "$packageName" "$installerType" "$packageParameters AGREETOLICENSE=Yes $silentArgs" "$url" "$url64"

