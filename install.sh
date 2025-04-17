#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Check for and remove existing CH34x-related kernel modules
KERNEL_DIR="/lib/modules/$(uname -r)/kernel/drivers/usb/serial"
EXISTING_MODULES=$(find "$KERNEL_DIR" -type f \( -name "ch341.ko" -o -name "ch340.ko" -o -name "ch34x.ko" \))

if [ -n "$EXISTING_MODULES" ]; then
    echo "Found the following existing CH34x-related kernel module files:"
    echo "$EXISTING_MODULES"
    echo "Removing them to avoid conflicts..."
    sudo rm -rf $EXISTING_MODULES
    echo "Removed existing CH34x kernel modules."
fi

# Install required build tools and kernel headers
echo "Updating package lists..."
sudo apt update
echo "Installing build-essential and kernel headers..."
sudo apt install -y build-essential linux-headers-$(uname -r)

sudo apt install gcc-12

# Print a starting message
echo "Starting CH34x driver installation..."

# Unload existing CH340/CH341 drivers if they are loaded
sudo rmmod ch34x || true
sudo rmmod ch341 || true

# Clone the repository into the home directory if not already present
REPO_DIR="$HOME/ch340-ubuntu-22.04-fix"
if [ ! -d "$REPO_DIR" ]; then
    echo "Cloning the CH34x driver repository..."
    git clone https://github.com/Vishal-Mutha/ch340-ubuntu-22.04-fix.git "$REPO_DIR"
fi

# Change to the repository directory
cd "$REPO_DIR" || { echo "Failed to enter $REPO_DIR"; exit 1; }

# Compile the driver
echo "Building the driver..."
sudo make clean
sudo make

# Load the driver
echo "Loading the driver..."
sudo insmod ch34x.ko

# Remove conflicting package (brltty can interfere with serial ports)
echo "Removing brltty to avoid conflicts..."
sudo apt remove -y brltty

# Verify installation
echo -e "\nInstallation complete!"
echo "Plug in your CH340/CH341 device and check for /dev/ttyUSB* with:"
echo "  ls /dev/ttyUSB*"
