# Installation Instructions for CH340 Driver Fix on Ubuntu 22.04

## Prerequisites
Before installing the CH340 driver fix, ensure your system has the required tools and kernel headers:
```bash
sudo apt update
sudo apt install build-essential linux-headers-$(uname -r)
```

## Step 1: Automated Installation
You can go through the installation using `install.sh`:

```bash
chmod +x install.sh
./install.sh
```

If you want to manually install, follow these steps:

## Step 2: Clone the Repository
First, clone the repository containing the fixed driver:

```bash
git clone https://github.com/Vishal-Mutha/ch340-ubuntu-22.04-fix.git
cd ch340-ubuntu-22.04-fix
```

## Step 3: Unload Existing CH340 Drivers
Before installing the fixed driver, remove any existing CH340 drivers:

```bash
sudo rmmod ch34x
```
**or**
```bash
sudo modprobe -r ch34x
```

Also remove ch341 driver if there exists any:
```bash
sudo rmmod ch341
```
**or**
```bash
sudo modprobe -r ch341
```

## Step 4: Compile and Install the Fixed Driver

```bash
sudo make clean
sudo make
sudo make load
```

## Step 5: Remove Conflicting Packages
Ubuntu includes `brltty`, which can interfere with serial devices. Remove it:

```bash
sudo apt remove brltty
```

## Step 6: Verify Installation
After plugging in your device, check if it is recognized:

```bash
ls /dev/ttyUSB*
```
If the device appears (e.g., `/dev/ttyUSB0`), the driver is successfully installed.

---

### Notes
- Rebooting the system after installation may help apply the changes.

If the issue persists, feel free to open an issue in this repository. 🚀
