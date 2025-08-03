# 📋 Installation Guide

## Prerequisites
- **Android Device**: Rooted with Magisk v20.4+ or KernelSU
- **WebUI App**: KsuWebUI Standalone or MMRL (for full WebUI access)

## 🚀 Quick Installation Steps

### 1. Download & Install
```bash
# Method 1: Direct Flash (Recommended)
1. Download stellar-tweaks.zip from releases
2. Open Magisk Manager or KernelSU Manager
3. Go to Modules → Install from storage
4. Select stellar-tweaks.zip
5. Reboot device

# Method 2: ADB Install
adb push stellar-tweaks.zip /sdcard/Download/
# Then flash via Manager app
```

### 2. WebUI Setup
```bash
# For KsuWebUI Standalone users:
- Module automatically opens WebUI interface
- Access via: Apps → KsuWebUI → Stellar Tweaks

# For MMRL users:
- Open MMRL app
- Navigate to Modules
- Find "Stellar Tweaks" → WebUI button

# Manual WebUI access:
su -c "sh /data/adb/modules/stellar/action.sh"
```

### 3. Verify Installation
```bash
# Check if module is active:
su -c "ls /data/adb/modules/ | grep stellar"

# Check daemon status:
su -c "ps | grep stellars"

# View logs:
su -c "cat /data/adb/.config/stellar/stellar.log"
```

## ⚡ Features Overview

### 🎮 Gaming Mode
- **Auto-detection**: Recognizes games from gamelist.json
- **Performance profiles**: Switches to high-performance mode
- **Thermal management**: Prevents overheating during gaming

### 🔋 Battery Optimization
- **Lite Mode**: Extends battery life for daily use
- **Smart scaling**: Adjusts CPU/GPU frequency intelligently
- **Background app management**: Limits unnecessary processes

### 🌐 WebUI Interface
- **Real-time monitoring**: CPU, GPU, thermal status
- **Profile switching**: Normal, Gaming, Powersave modes
- **Settings management**: Toggle features on/off
- **Game list editor**: Add/remove games for optimization

### 🏗️ Chipset Support
- **Snapdragon**: Full optimization support
- **MediaTek**: Complete feature set
- **Exynos**: Advanced thermal control
- **Unisoc**: Basic optimizations
- **Google Tensor**: Specialized tuning

## 🛠️ Manual Configuration

### Add Games to Optimization List
```bash
# Edit gamelist via WebUI or manually:
su -c "echo 'com.your.game.package' >> /data/adb/.config/stellar/gamelist.json"
```

### Custom CPU Governors
```bash
# Set custom governors:
echo "performance" > /data/adb/.config/stellar/custom_game_cpu_gov
echo "powersave" > /data/adb/.config/stellar/custom_powersave_cpu_gov
```

### Enable/Disable Features
```bash
# Via WebUI settings or command line:
# Lite Mode, Zeta Tweak, Do Not Disturb, etc.
```

## 🔧 Troubleshooting

### Module Not Loading
```bash
# Check Magisk/KernelSU logs:
magisk --log
# or
dmesg | grep stellar
```

### WebUI Not Accessible
```bash
# Install required WebUI app:
# KsuWebUI Standalone: https://github.com/5ec1cff/KsuWebUIStandalone
# MMRL: https://github.com/DerGoogler/MMRL
```

### Performance Issues
```bash
# Reset to defaults:
su -c "rm -rf /data/adb/.config/stellar"
# Reboot and reconfigure via WebUI
```

## 📱 Supported Devices
- **All Android versions**: 7.0+ (API 24+)
- **All architectures**: ARM64, ARM32
- **All chipsets**: Snapdragon, MediaTek, Exynos, Unisoc, Tensor

## 🆘 Support
- **Telegram Channel**: [@hosshi_prjkt](https://t.me/hosshi_prjkt)
- **Telegram Group**: [Discussions](https://t.me/hosshi_chat)
- **GitHub Issues**: [Report Bug](https://github.com/kanaodnd/Stellar-Tweaks/issues)

## ⚠️ Important Notes
- **Backup**: Always create a NANDroid backup before flashing
- **Testing**: Test on non-critical device first
- **Compatibility**: Some features may vary by device/chipset
- **Updates**: Check releases regularly for improvements