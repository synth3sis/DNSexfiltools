# DNS Exfil Tools

Simple penetration testing tools to execute DNS exfiltration and elude common detection methods.

## Client Exfiltration
Deploy these tools on the target machine to exfiltrate files through DNS requests.
I'm still developing the client side for more than one programming language, to provide more compatibility with the system you are testing.

| Language | Available | Encryption |
| ------ | ------ | ------|
| python3 | :heavy_check_mark: | :soon: |
| python2 | :soon: | :soon: |
| powershell | :soon: | :soon: |
| Compiled C++ | :soon: | :soon: |

### Features
| | |
| ------ | ------ | 
| :heavy_check_mark: | Set timeout between DNS requests to slow down exfiltration and prevent detection |
| :heavy_check_mark: | Set random timeout between requests to prevent periodically checks detection |
| :heavy_check_mark: | Set fake domain or legit domain for DNS queries, your machine will respond to both |
| :heavy_check_mark: | Set exfiltration chunks length as third level domains
| :heavy_check_mark: | Optional: print server's response to verify queries |
| :x: | Optional: file encryption to prevent network sniffers to rebuild exfiltrated artifacts |

## Fake DNS Server
The server module will provide a simple fake DNS server to get client's queries
