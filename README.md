# DNS Exfil Tools

Simple penetration testing tools to execute exfiltration through DNS and elude common detection methods.

Modules caption:
:heavy_check_mark: Available
:large_blue_circle: Under development
:white_circle: To be developed


## Client Exfiltration
Deploy these tools on the target machine to exfiltrate files through DNS requests.
I'm still developing the client side for more than one programming language, to provide more compatibility with the system you are testing.

| Language | Available | Encryption |
| ------ | ------ | ------|
| python3 | :heavy_check_mark: | :large_blue_circle: |
| python2 | :large_blue_circle: | :large_blue_circle: |
| powershell | :white_circle: | :white_circle: |
| Compiled C++ | :white_circle: | :white_circle: |



### Features
| | |
| ------ | ------ | 
| :heavy_check_mark: | Set timeout between DNS requests to slow down exfiltration and prevent detection |
| :heavy_check_mark: | Set random timeout between requests to prevent periodically checks detection |
| :heavy_check_mark: | Set fake domain or legit domain for DNS queries, your machine will respond to both |
| :heavy_check_mark: | Set exfiltration chunks length as third level domains
| :heavy_check_mark: | Optional: print server's response to verify queries |
| :large_blue_circle: | Optional: file encryption to prevent network sniffers to rebuild exfiltrated artifacts |

---

## Fake DNS Server
Developed with Python3, the server module will provide a simple fake DNS server to get client's queries from your attacking machine, and responde with a spoofed IP of your choice (default is google.com's).

### Features
| | |
| ------ | ------ | 
| :heavy_check_mark: | Set custom IP to spoof as record A response |
| :heavy_check_mark: | Set custom domain for further automated file decode |
| :heavy_check_mark: | Set custom UDP port for DNS service (default is 53) |
| :large_blue_circle: | Optional: automated file decode/save |
| :large_blue_circle: | Optional: file decryption and save |
