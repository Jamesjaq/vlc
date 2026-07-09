# VLC Infinity Installation Guide

This guide provides step-by-step instructions for installing the VLC Infinity Lua extension on all supported platforms: Windows, macOS, Linux, Android, and iOS.

## Prerequisites

- **VLC Media Player** version 3.0 or newer
- Basic file management skills
- Administrator/root access (for some platforms)

---

## Windows Installation

### Method 1: Manual Installation

1. **Download the extension file:**
   - Download `vlc-infinity.lua` from the [GitHub repository](https://github.com/Jamesjaq/vlc/tree/vlc-infinity/share/lua/extensions).

2. **Locate VLC's extensions directory:**
   - Open File Explorer and navigate to one of these locations:
     - `C:\Program Files\VideoLAN\VLC\lua\extensions\` (if VLC is installed in Program Files)
     - `C:\Program Files (x86)\VideoLAN\VLC\lua\extensions\` (for 32-bit VLC on 64-bit Windows)
     - `%APPDATA%\vlc\lua\extensions\` (user-specific extensions directory)
   
   - To access `%APPDATA%`, press `Win + R`, type `%APPDATA%`, and press Enter.

3. **Copy the extension file:**
   - Copy `vlc-infinity.lua` into the `extensions` directory.
   - If the `lua` or `extensions` folder doesn't exist, create them manually.

4. **Restart VLC:**
   - Close VLC completely.
   - Reopen VLC Media Player.

5. **Activate the extension:**
   - Go to `View` menu → Look for `VLC Infinity` option.
   - Click on it to open the VLC Infinity dialog.

### Method 2: Using PowerShell Script (Advanced)

1. **Download the PowerShell script:**
   - Create a file named `install.ps1` with the following content:
   ```powershell
   # VLC Infinity Installation Script for Windows
   $VLCExtDir = "$env:APPDATA\vlc\lua\extensions"
   $ExtensionFile = "vlc-infinity.lua"
   
   if (-not (Test-Path $VLCExtDir)) {
       New-Item -ItemType Directory -Path $VLCExtDir -Force | Out-Null
   }
   
   Copy-Item $ExtensionFile -Destination $VLCExtDir -Force
   Write-Host "VLC Infinity extension installed to $VLCExtDir"
   Write-Host "Please restart VLC to activate the extension."
   ```

2. **Run the script:**
   - Open PowerShell as Administrator.
   - Navigate to the directory containing the script.
   - Run: `Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process`
   - Run: `.\install.ps1`

3. **Restart VLC** and activate the extension from the `View` menu.

---

## macOS Installation

### Method 1: Manual Installation

1. **Download the extension file:**
   - Download `vlc-infinity.lua` from the [GitHub repository](https://github.com/Jamesjaq/vlc/tree/vlc-infinity/share/lua/extensions).

2. **Locate VLC's extensions directory:**
   - Open Finder.
   - Press `Cmd + Shift + G` to open "Go to Folder".
   - Paste this path: `~/Library/Application Support/org.videolan.vlc/lua/extensions/`
   - Press Enter.

3. **Copy the extension file:**
   - If the `lua/extensions` folder doesn't exist, create it manually.
   - Copy `vlc-infinity.lua` into the `extensions` directory.

4. **Restart VLC:**
   - Close VLC completely.
   - Reopen VLC Media Player.

5. **Activate the extension:**
   - Go to `View` menu → Look for `VLC Infinity` option.
   - Click on it to open the VLC Infinity dialog.

### Method 2: Using Terminal Script

1. **Download the installation script:**
   - Download `install.sh` from the [GitHub repository](https://github.com/Jamesjaq/vlc/tree/vlc-infinity).

2. **Run the script:**
   - Open Terminal.
   - Navigate to the directory containing `install.sh` and `vlc-infinity.lua`.
   - Run: `chmod +x install.sh`
   - Run: `./install.sh`

3. **Restart VLC** and activate the extension from the `View` menu.

---

## Linux Installation

### Method 1: Manual Installation

1. **Download the extension file:**
   - Download `vlc-infinity.lua` from the [GitHub repository](https://github.com/Jamesjaq/vlc/tree/vlc-infinity/share/lua/extensions).

2. **Locate VLC's extensions directory:**
   - Open a terminal.
   - The extensions directory is typically at: `~/.local/share/vlc/lua/extensions/`

3. **Create the directory if it doesn't exist:**
   ```bash
   mkdir -p ~/.local/share/vlc/lua/extensions/
   ```

4. **Copy the extension file:**
   ```bash
   cp vlc-infinity.lua ~/.local/share/vlc/lua/extensions/
   ```

5. **Restart VLC:**
   - Close VLC completely.
   - Reopen VLC Media Player.

6. **Activate the extension:**
   - Go to `View` menu → Look for `VLC Infinity` option.
   - Click on it to open the VLC Infinity dialog.

### Method 2: Using Installation Script

1. **Download the installation script:**
   - Download `install.sh` from the [GitHub repository](https://github.com/Jamesjaq/vlc/tree/vlc-infinity).

2. **Run the script:**
   - Open a terminal in the directory containing `install.sh` and `vlc-infinity.lua`.
   - Run: `chmod +x install.sh`
   - Run: `./install.sh`

3. **Restart VLC** and activate the extension from the `View` menu.

### Method 3: Using Package Manager (Debian/Ubuntu)

If VLC is installed via package manager, the extensions directory may be at `/usr/share/vlc/lua/extensions/`. However, this typically requires root access:

```bash
sudo cp vlc-infinity.lua /usr/share/vlc/lua/extensions/
```

---

## Android Installation

Android support for VLC Lua extensions is **limited**. VLC for Android has a restricted extension system. Here are the available options:

### Option 1: Using VLC for Android with File Manager

1. **Download the extension file:**
   - Download `vlc-infinity.lua` from the [GitHub repository](https://github.com/Jamesjaq/vlc/tree/vlc-infinity/share/lua/extensions).

2. **Transfer the file to your Android device:**
   - Use a file manager app or connect your device to a computer via USB.
   - Transfer `vlc-infinity.lua` to your device's storage.

3. **Locate VLC's extensions directory:**
   - On most Android devices, the path is: `/sdcard/Android/data/org.videolan.vlc/files/lua/extensions/`
   - You may need to enable "Show hidden files" in your file manager.

4. **Copy the extension file:**
   - Copy `vlc-infinity.lua` into the `extensions` directory.
   - Create the directory if it doesn't exist.

5. **Restart VLC:**
   - Close VLC completely.
   - Reopen VLC Media Player.

### Option 2: Using ADB (Android Debug Bridge)

For advanced users with Android SDK tools installed:

```bash
adb push vlc-infinity.lua /sdcard/Android/data/org.videolan.vlc/files/lua/extensions/
```

### Limitations

- VLC for Android has limited Lua extension support compared to desktop versions.
- Some features (like dialog boxes) may not work as expected on mobile.
- Network access may require additional permissions.

---

## iOS Installation

iOS support for VLC Lua extensions is **very limited** due to Apple's sandboxing restrictions. VLC for iOS does not officially support custom Lua extensions in the same way as desktop versions.

### Workaround: Using VLC for iOS with Streaming

1. **Use VLC for iOS as a player only:**
   - VLC for iOS can play streams directly if you provide the stream URL.
   - You can use the web app or another device to browse channels and movies, then copy the stream URL.

2. **Add streams manually:**
   - In VLC for iOS, go to `Network Streams`.
   - Paste the stream URL directly.
   - VLC will attempt to play the stream.

### Alternative: Use Desktop VLC

For full VLC Infinity functionality, use the extension on desktop platforms (Windows, macOS, Linux) and stream content to your iOS device via AirPlay or other streaming protocols.

---

## Troubleshooting

### Extension not appearing in View menu

1. **Verify the file location:**
   - Ensure `vlc-infinity.lua` is in the correct `extensions` directory for your OS.

2. **Check file permissions:**
   - Ensure the file is readable by your user account.
   - On Linux/macOS, run: `chmod 644 vlc-infinity.lua`

3. **Check VLC version:**
   - Ensure VLC version is 3.0 or newer.
   - Go to `Help > About` to check your version.

4. **Clear VLC cache:**
   - Close VLC.
   - Delete the VLC cache directory:
     - **Windows:** `%APPDATA%\vlc\`
     - **macOS:** `~/Library/Application Support/org.videolan.vlc/`
     - **Linux:** `~/.local/share/vlc/`
   - Reopen VLC.

### Extension crashes or doesn't load

1. **Check VLC logs:**
   - Go to `Tools > Messages` to view error logs.
   - Look for any error messages related to `vlc-infinity`.

2. **Verify network connectivity:**
   - Ensure your device has internet access for fetching IPTV and movie data.

3. **Check for Lua API compatibility:**
   - Some older VLC versions may not support all Lua APIs used by the extension.
   - Try upgrading VLC to the latest version.

### Streams not playing

1. **Verify stream health:**
   - The extension includes a stream health checker. If a stream fails the health check, it won't play.
   - Try selecting a different channel or movie.

2. **Check network connectivity:**
   - Ensure you have a stable internet connection.

3. **Check VLC's network settings:**
   - Go to `Tools > Preferences > Input / Codecs` and verify network settings.

---

## Uninstallation

To remove the VLC Infinity extension:

1. **Locate the extension file:**
   - Navigate to your VLC extensions directory (see paths above for each OS).

2. **Delete the file:**
   - Delete `vlc-infinity.lua`.

3. **Restart VLC:**
   - Close and reopen VLC.
   - The extension will no longer appear in the `View` menu.

---

## Support

For issues, feature requests, or contributions, visit the [GitHub repository](https://github.com/Jamesjaq/vlc/tree/vlc-infinity).
