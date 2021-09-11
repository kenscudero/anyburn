# Do not remove this test for UTF-8: if “Ω” doesn’t appear as greek uppercase omega letter enclosed in quotation marks, you should use an editor that supports UTF-8, not this one.
$ErrorActionPreference = 'Stop';

$packageName	= 'anyburn'
$softwareName	= 'AnyBurn*'
$installerType	= 'EXE'
$silentArgs	= '/S'
$validExitCodes	= @(0, 3010, 1605, 1614, 1641)
$Bits		= Get-ProcessorBits

If ( $Bits -eq 64 ) {
	$sUninstallPathParent = "${Env:ProgramFiles}"
} Else {
	$sUninstallPathParent = "${Env:ProgramFiles(x86)}"
}
$sUninstallPath = ( Join-Path -Path ( Join-Path -Path $sUninstallPathParent -ChildPath "AnyBurn" ) -ChildPath "uninstall.exe" )

Start-CheckandStop "AnyBurn"

If ( $sUninstallPath.Length ) {
	Uninstall-ChocolateyPackage $packageName $installerType $silentArgs $sUninstallPath $validExitCodes
}
