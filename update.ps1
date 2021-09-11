# Do not remove this test for UTF-8: if “Ω” doesn’t appear as greek uppercase omega letter enclosed in quotation marks, you should use an editor that supports UTF-8, not this one.
if ( -not ( Test-Path -Path "$env:ProgramData\Chocolatey" ) ) {
	Write-Error -Message "Chocolatey is not installed" -ErrorAction Stop
}

import-module au

$domain		= 'https://www.anyburn.com'
$releases	= $domain + '/download.php'
$regexFileType	= '\.' + 'exe'
$regexBit	= '-bit'

function global:au_SearchReplace {
	@{
		".\tools\chocolateyInstall.ps1" = @{
			"($i)(^\s*url\s*=\s*)('.*')"			= "`$1'$($Latest.URL32)'"
			"($i)(^\s*checksum\s*=\s*)('.*')"		= "`$1'$($Latest.Checksum32)'"
			"($i)(^\s*filetype\s*=\s*)('.*')"		= "`$1'$($Latest.FileType)'"

			"($i)(^\s*url64\s*=\s*)('.*')"			= "`$1'$($Latest.URL64)'"
			"($i)(^\s*checksum64\s*=\s*)('.*')"		= "`$1'$($Latest.Checksum64)'"
			"($i)(^\s*filetype64\s*=\s*)('.*')"		= "`$1'$($Latest.FileType64)'"
		}
	}
}

function au_GetLatestVars {
	$myFuncName = $MyInvocation.MyCommand
	$c = 0; foreach ($i in $p) {
		Write-Verbose "$($myFuncName):c=$c"
		$o = ($c * 32) + 32
		Write-Verbose "$($myFuncName):o=$o"
		$u = "URL$o"
		if ($c -eq 0) { $o = $null }
		Write-Verbose "$($myFuncName):o=$o"
		$v = "Version$o"; $ft = "FileType$o"
		Write-Verbose "$($myFuncName):u=$u"; Write-Verbose "$($myFuncName):v=$v"; Write-Verbose "$($myFuncName):ft=$ft"
		$u1 = ($domain + '/' + $($url[$c]))
		Write-Verbose "$($myFuncName):u1=$u1"
		Write-Output "$($u) = '$u1'; $($v) = [Float]$($version[$c]); $($ft) = '$($filetype[$c])';"
		$c++
	}
}

function global:au_GetLatest {
	$myFuncName = $MyInvocation.MyCommand
	Write-Verbose "$($myFuncName):releases=$releases"
	$download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing
	Write-Verbose "$($myFuncName):download_page=$download_page"
	Write-Verbose "$($myFuncName):regexFileType=$regexFileType"
	Write-Verbose "$($myFuncName):regexBit=$regexBit"
	$p = $download_page.Links | ? href -match $regexFileType | % OuterHTML
	Write-Verbose "$($myFuncName):p=$p"
	Write-Verbose "$($myFuncName):p.Count=$($p.Count)"
	$c = 0; foreach ($i in $p) { Write-Verbose "$($myFuncName):p[$c]=$i"; $c++}
	$ub = (New-Object 'string[]' $($p.Count))
	$url = (New-Object 'string[]' $($p.Count))
	$filetype = (New-Object 'string[]' $($p.Count))
	$version = (New-Object 'string[]' $($p.Count))
	$c = 0; foreach ($i in $p) {
		Write-Verbose "$($myFuncName):p[$c]=$i"
		$ub[$c] = ( ( ( ( $i.split('Download') -match $regexBit )[0].split($regexBit).split('\)')[0] ) -replace('\(','') ).split(' ') )[-1]
		Write-Verbose "$($myFuncName):ub[$c] = $($ub[$c])"
		$filetype[$c] = ( ( $i.ToUpper().split('"') -match '\.' )[0].split('\.') )[-1]
		Write-Verbose "$($myFuncName):filetype[$c] = $($filetype[$c])"
		$url[$c] = ( $i.split('"') ) -match $filetype[$c].ToLower()
		Write-Verbose "$($myFuncName):url[$c] = $($url[$c])"
		$version[$c] = ( ( $i.split('Download') ) -match ' v[0-9]' ).split(' v').split(' ')[2]
		Write-Verbose "$($myFuncName):version[$c] = $($version[$c])"
		$c++
	}
	$s = (au_GetLatestVars)
	Write-Verbose "$($myFuncName):s=$s"
	Invoke-Expression "@{ $s }"
}

#au_GetLatest
update

