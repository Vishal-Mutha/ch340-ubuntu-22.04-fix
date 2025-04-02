# CH34x USB-to-Serial Driver for Linux

This repository contains a modified version of the CH34x USB-to-serial driver (`ch34x.c`) originally developed by WCH (Winchiphead) for their CH340/CH341 USB-to-serial adapter chips. The driver has been updated to compile and work on modern Linux kernels, specifically tested on **Linux 6.8.0-57-generic**.

## What Does This Driver Do?
The CH34x driver allows your Linux system to communicate with devices connected via a CH340 or CH341 USB-to-serial adapter. These adapters are commonly used to connect microcontrollers, old serial devices, or other hardware to a computer over USB.

## Why This Version?
The original driver from WCH (circa 2013) was written for older Linux kernels (2.6.x to around 3.x). As Linux evolved, some of the old code stopped working due to changes in kernel rules. This version updates the driver to fix compilation errors and ensure compatibility with Linux 6.8.0-57-generic, while keeping the original functionality intact.

## Changes Made
Here’s a summary of the updates made to `ch34x.c` to make it work on modern kernels:

### 1. Fixed Wait Queue Issues
- **Problem**: The original code used outdated wait queue methods (`interruptible_sleep_on`) that don’t work in newer kernels. It also had a bug in `ch34x_close` where a wait queue entry (`wait`) was declared twice, causing a "redeclaration" error.
- **Fix**: 
  - Replaced `interruptible_sleep_on` with `wait_event_interruptible` in `wait_modem_info`.
  - In `ch34x_close`, removed the extra `wait_queue_entry_t wait;` line and used `DEFINE_WAIT(wait)` alone to create the wait queue entry properly.
- **Why**: Wait queues help the driver pause and wait for tasks (like sending data) to finish. The fixes make this work with Linux 6.8.0’s rules.

### 2. Updated Headers
- **Problem**: The old code used `<asm/uaccess.h>`, which is outdated, and missed `<linux/wait.h>` needed for wait queues.
- **Fix**: 
  - Changed to `<linux/uaccess.h>` (modern standard for accessing user memory).
  - Added `<linux/wait.h>` for wait queue support.
- **Why**: Headers are like instruction manuals for the kernel. Using the right ones ensures the driver can talk to Linux correctly.

### 3. Improved Function Signatures
- **Problem**: Functions `ch34x_write_room` and `ch34x_chars_in_buffer` returned `int`, but modern kernels expect `unsigned int`.
- **Fix**: Updated both to return `unsigned int` consistently.
- **Why**: This matches what the kernel expects for counting bytes, avoiding warnings or errors.

### 4. Added Safety Checks
- **Problem**: The code could crash if it tried to use a `tty` (terminal) object that didn’t exist.
- **Fix**: Added `if (tty)` checks in `ch34x_close` to ensure `tty` isn’t null before using it.
- **Why**: This prevents the driver from breaking if something unexpected happens.

### 5. Kept New Features
- The updated code retains improvements from later versions, like better baud rate handling (e.g., support for 921600 and 307200) and mark/space parity options in `ch34x_set_termios`.

## Included Installation Script
This repository includes an `install.sh` script to automate the installation process. It:
- Unloads any existing CH34x/CH341 drivers.
- Clones the repository (if not already present).
- Builds and loads the driver.
- Removes the `brltty` package, which can conflict with serial ports.

  To run the `install.sh` follow these commands:
  ```bash
  chmod +x install.sh
  ./install.sh

To manually install the driver follow the `install.md` for the instrutions.


## How to Use This Driver

### Prerequisites
- A Linux system running kernel 6.8.0-57-generic (or similar).
- GCC and kernel headers installed. On Ubuntu, install them with:
  ```bash
  sudo apt update
  sudo apt install build-essential linux-headers-$(uname -r)
