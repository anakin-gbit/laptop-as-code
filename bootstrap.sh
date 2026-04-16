#!/bin/bash
set -e # Exit on error

echo "--- STARTING BOOTSTRAP: $(date) ---"

# 1. Prove we can see the hardware
echo "Checking Hardware..."
echo "CPU: $(lscpu | grep 'Model name' | cut -d ':' -f 2 | xargs)" >> /home/ubuntu/build_log.txt
echo "RAM: $(free -h | grep 'Mem:' | awk '{print $2}')" >> /home/ubuntu/build_log.txt

# 2. Prove we have network access
echo "Testing Network..."
ping -c 3 google.com > /dev/null && echo "Network: OK" >> /home/ubuntu/build_log.txt

echo "--- BOOTSTRAP COMPLETE ---"
echo "Check /home/ubuntu/build_log.txt for results."