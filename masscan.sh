#!/bin/bash

# Check if an argument was provided
if [ -z "$1" ]; then
    echo "Usage: $0 <target_ip_range>"
    exit 1
fi

# Set the target IP range from the argument
TARGET_IP_RANGE="$1"

# Set the output files
MASSCAN_OUTPUT="masscan_results.txt"
NMAP_OUTPUT="nmap_results.txt"

# Run masscan to scan for port 80
echo "Running masscan to scan for port 80..."
masscan -p80 $TARGET_IP_RANGE --rate=1000 -oL $MASSCAN_OUTPUT

# Extract IPs with open port 80 from masscan results
echo "Extracting IPs from masscan results..."
awk '/open/ {print $4}' $MASSCAN_OUTPUT > ips.txt

# Run nmap to scan the banner for the extracted IPs with optimizations
echo "Running nmap to scan the banner of the extracted IPs..."
nmap -iL ips.txt -p 80 --script=banner -T5 -n --min-rate=1000 -oN $NMAP_OUTPUT

# Clean up
rm ips.txt

echo "Scan complete. Results saved in $NMAP_OUTPUT"

