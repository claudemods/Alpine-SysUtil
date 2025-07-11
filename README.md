<p align="center">
  <img src="https://i.postimg.cc/d1VR617H/alpine.webp">
</p>

<div align="center">
  <a href="https://www.alpinelinux.org/" target="_blank">
    <img src="https://img.shields.io/badge/DISTRO-Alpine-00FFFF?style=for-the-badge&logo=Alpine">
  </a>
</div>



  <a href="https://www.deepseek.com/" target="_blank">
    <img alt="Homepage" src="https://i.postimg.cc/Hs2vbbZ8/Deep-Seek-Homepage.png" style="height: 30px; width: auto;">
  </a>

<div align="center">
  <h1>🏔️ Alpine-SysUtil</h1>

A comprehensive repair tool for Alpine Linux that fixes common system issues with a simple menu-driven interface.

<h2><a href="https://github.com/claudemods/Alpine-SysUtil/tree/main/photos">📸 Click Here For Photos</a></h2>

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
