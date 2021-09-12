# Do not remove this test for UTF-8: if “Ω” doesn’t appear as greek uppercase omega letter enclosed in quotation marks, you should use an editor that supports UTF-8, not this one.
$ErrorActionPreference = 'Stop';

$toolsDir   	= "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$packageName	= 'anyburn.install'
$softwareName	= 'AnyBurn*'
$url		= 'https://www.anyburn.com/anyburn_setup.exe'
$url64		= 'https://www.anyburn.com/anyburn_setup_x64.exe'
$fileType	= ( $(Split-Path -leaf $url) -split('\.') )[-1].ToUpper()
$fileType64	= ( $(Split-Path -leaf $url64) -split('\.') )[-1].ToUpper()
$checksum	= '572542287AD9F6227F4383A8B3CB968A6AD68104D063FFF76991DEAD64A1CF18'
$checksumType	= 'sha256'
$checksum64	= '2631E2FB7B282B56F206DE79AA69CC3CFFC9A518717EC6B496C5CF176E3E18AB'
$checksumType64	= 'sha256'
$silentArgs	= '/S'
$validExitCodes	= @(0)

$packageArgs = @{
  PackageName		= $packageName
  SoftwareName		= $softwareName

  FileType		= $fileType
  FileType64		= $fileType64

  Url			= $url
  Url64bit		= $url64

  Checksum		= $checksum
  Checksum64		= $checksum64
  ChecksumType		= $checksumType
  ChecksumType64	= $checksumType64

  SilentArgs		= $silentArgs

  ValidExitCodes	= $validExitCodes
}

Install-ChocolateyPackage @packageArgs

$name			= ( $packageArgs.SoftwareName )
$installLocation	= ( Get-AppInstallLocation $name )
if ($installLocation) {
    Write-Host "'$name' installed to '$installLocation'"

    $installName = ( $name.replace('*',$null) )
    $application = ( Join-Path -Path $installLocation -ChildPath "$installName.exe" )
    Register-Application $application $installName
    Write-Host "'$name' registered as '$installName'"
}
else { Write-Warning "Can not find '$name' install location" }
