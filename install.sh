#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Unload existing CH340 drivers
sudo rmmod ch34x 2>/dev/null || true
sudo modprobe -r ch34x 2>/dev/null || true

sudo rmmod ch341 2>/dev/null || true
sudo modprobe -r ch341 2>/dev/null || true

# Clone the repository if not already cloned
if [ ! -d "ch340-ubuntu-22.04-fix" ]; then
    git clone https://github.com/Vishal-Mutha/ch340-ubuntu-22.04-fix.git
fi

cd ch340-ubuntu-22.04-fix

# Compile and install the fixed driver
sudo make clean
sudo make
sudo make load

# Remove conflicting package
sudo apt remove -y brltty

# Verify installation
echo "\nInstallation complete. Plug in your device and check with: ls /dev/ttyUSB*"
