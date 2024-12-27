#!/bin/bash

# Check if sufficient arguments were provided
if [ $# -lt 2 ]; then
    echo "Usage: $0 <target_ip_range> -p<port>"
    exit 1
fi

# Set the target IP range and port from the arguments
TARGET_IP_RANGE="$1"
PORT="$2"

# Extract the port number from the argument (e.g., -p80 -> 80)
PORT_NUMBER="${PORT#-p}"

# Set the output files
MASSCAN_OUTPUT="masscan_results.txt"
NMAP_OUTPUT="nmap_results.txt"

# Run masscan to scan for the specified port
echo "Running masscan to scan for port $PORT_NUMBER..."
masscan -p$PORT_NUMBER $TARGET_IP_RANGE --rate=1000 -oL $MASSCAN_OUTPUT

# Extract IPs with the specified port open from masscan results
echo "Extracting IPs from masscan results..."
awk '/open/ {print $4}' $MASSCAN_OUTPUT > ips.txt

# Function to run nmap on each IP
nmap_scan() {
    local ip=$1
    nmap -p $PORT_NUMBER --script=banner -T5 -n --min-rate=1000 -oN "nmap_ip_$ip.txt" $ip
}

export -f nmap_scan

# Run nmap in parallel for the extracted IPs
echo "Running nmap in parallel for the extracted IPs..."
parallel -j 4 nmap_scan :::: ips.txt

# Combine individual nmap output files into one
cat nmap_ip_*.txt > $NMAP_OUTPUT

# Clean up
rm ips.txt nmap_ip_*.txt

echo "Scan complete. Results saved in $NMAP_OUTPUT"

