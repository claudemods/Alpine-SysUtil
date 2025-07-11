# Alpine Linux System Utility

A comprehensive repair tool for Alpine Linux that fixes common system issues with a simple menu-driven interface.

![Banner Screenshot](screenshot.png)

## Features

- Simple, intuitive terminal interface
- Password-protected operations
- Fixes multiple common Alpine Linux issues
- Color-coded output for better visibility
- Lightweight and fast execution

## What This Script Fixes

### Package Management Issues
- 🛠️ Fixes "failed to synchronize all databases" errors for apk
- 🔓 Resolves "unable to lock database" for apk
- 📦 Repairs corrupted packages and broken dependencies
- 🔑 Fixes GPG key errors and corrupted PGP signatures

### System Issues
- ⏰ Corrects clock time synchronization problems
- 🖥️ Repairs botched updates and login failures
- 📜 Provides quick access to system logs

### Network Issues
- 🌐 Fixes general network connectivity problems
- 🔄 Resolves issues with DNSCrypt
- 📶 Repairs NetworkManager configuration

## Installation

```bash
wget https://github.com/claudemods/Alpine-SysUtil/blob/main/tui-script.sh
chmod +x alpine-sysutil.sh
sudo ./alpine-sysutil.sh
