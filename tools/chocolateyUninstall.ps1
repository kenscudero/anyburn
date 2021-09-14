# Do not remove this test for UTF-8: if “Ω” doesn’t appear as greek uppercase omega letter enclosed in quotation marks, you should use an editor that supports UTF-8, not this one.
$ErrorActionPreference = 'Stop';

$packageName	= 'anyburn2'
$softwareName	= 'AnyBurn*'
$silentArgs	= '/S'
$validExitCodes	= @(0, 3010, 1605, 1614, 1641)
$Bits		= Get-ProcessorBits

If ( $Bits -eq 64 ) {
	$uninstallPathRoot	= "${Env:ProgramFiles}"
} Else {
	$uninstallPathRoot	= "${Env:ProgramFiles(x86)}"
}
$installName		= ( $softwareName.replace(' ','*') )
$uninstallPathParent	= ( Join-Path -Path $uninstallPathRoot -ChildPath $installName )
$uninstallName		= 'uninstall.exe'
$uninstallPath		= ( Join-Path -Path $uninstallPathParent -ChildPath $uninstallName )

Start-CheckandStop "$installName"

If ( $uninstallPath.Length ) {
	$uninstallerType	= ( ( Split-Path -leaf $uninstallPath ).split('.')[-1].ToUpper() )
	Uninstall-ChocolateyPackage $packageName $uninstallerType $silentArgs $uninstallPath $validExitCodes
}
