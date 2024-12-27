# **MASSCAN SCRIPT**

## What does this script do?
The script scans the subnet for online devices and sends the output for nmap to probe banner of the given IP address subnet and finally stores the gathered result in an output file.
    
## How to use?

First download the script by running the following

```
sudo apt install nmap masscan awk gawk parallel git
git clone https://github.com/kgvarunkanth/masscan-script.git
cd masscan-script
chmod +x masscan.sh
sudo bash masscan.sh 192.168.0.0/24
```
