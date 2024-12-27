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

# Function to run nmap on each IP
nmap_scan() {
    local ip=$1
    nmap -p 80 --script=banner -T5 -n --min-rate=1000 -oN "nmap_$ip.txt" $ip
}

export -f nmap_scan

# Run nmap in parallel for the extracted IPs
echo "Running nmap in parallel for the extracted IPs..."
parallel -j 4 nmap_scan :::: ips.txt

# Combine individual nmap output files into one
cat nmap_*.txt > $NMAP_OUTPUT

# Clean up
rm ips.txt nmap_*.txt

echo "Scan complete. Results saved in $NMAP_OUTPUT"

