# Do not remove this test for UTF-8: if “Ω” doesn’t appear as greek uppercase omega letter enclosed in quotation marks, you should use an editor that supports UTF-8, not this one.
$ErrorActionPreference = 'Stop';

$toolsDir   	= "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$packageName	= 'anyburn'
$url		= 'https://www.anyburn.com/anyburn_setup.exe'
$url64		= 'https://www.anyburn.com/anyburn_setup_x64.exe'
$fileType	= ( $(Split-Path -leaf $url) -split('\.') )[-1].ToUpper()
$fileType64	= ( $(Split-Path -leaf $url64) -split('\.') )[-1].ToUpper()
$checksum	= '572542287AD9F6227F4383A8B3CB968A6AD68104D063FFF76991DEAD64A1CF18'
$checksum64	= '2631E2FB7B282B56F206DE79AA69CC3CFFC9A518717EC6B496C5CF176E3E18AB'
$silentArgs	= '/S'

$packageArgs = @{
  packageName		= $packageName
  unzipLocation		= $toolsDir
  fileType		= $fileType
  fileType64		= $fileType64

  url			= $url
  url64			= $url64

  softwareName		= 'AnyBurn*'

  checksum		= $checksum
  checksum64		= $checksum64
  checksumType		= 'sha256'
  checksumType64	= 'sha256'

  silentArgs		= $silentArgs

  validExitCodes	= @(0)
}

Install-ChocolateyPackage @packageArgs
