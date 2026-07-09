# VLC Infinity Extension

## Overview
VLC Infinity is a powerful Lua extension for VLC Media Player that brings IPTV channels and public-domain movies directly into VLC's native interface. This extension allows you to browse, search, and play content without leaving VLC.

## Features
- **IPTV Channel Aggregator:** Pulls channels from iptv-org (index.m3u) with filtering by country and category.
- **Free Movies Integration:** Access public-domain movies from Internet Archive with search and genre filtering.
- **Universal Search:** Find channels or movies quickly.
- **Stream Health Checker:** Validates stream URLs before playback.
- **Electronic Program Guide (EPG):** (Coming Soon) Display now-playing and upcoming schedules.
- **Favorites & Watch History:** Save and manage your preferred content locally.
- **Cross-Platform Compatibility:** Designed to work across Windows, macOS, Linux, Android, and iOS (where VLC Lua extensions are supported).

## Installation

### Prerequisites
- VLC Media Player (version 3.0 or newer recommended)

### Manual Installation
1.  **Download the extension:** Download the `vlc-infinity.lua` file from the [GitHub repository](https://github.com/Jamesjaq/vlc/tree/main/share/lua/extensions).
2.  **Locate VLC's Lua extensions directory:**
    *   **Windows:** `C:\Program Files\VideoLAN\VLC\lua\extensions\` or `%APPDATA%\vlc\lua\extensions\`
    *   **macOS:** `~/Library/Application Support/org.videolan.vlc/lua/extensions/`
    *   **Linux:** `~/.local/share/vlc/lua/extensions/`
    *   **Android/iOS:** Manual installation is more complex and may require root access or specific file management tools. Refer to VLC's official documentation for your specific mobile platform.
3.  **Place the file:** Copy `vlc-infinity.lua` into the `extensions` directory.
4.  **Restart VLC:** Close and reopen VLC Media Player.

### Using the Installation Script (Linux/macOS)
1.  **Download the script and extension:** Download `install.sh` and `vlc-infinity.lua` from the [GitHub repository](https://github.com/Jamesjaq/vlc).
2.  **Make the script executable:** Open a terminal and navigate to the directory where you downloaded the files. Run:
    ```bash
    chmod +x install.sh
    ```
3.  **Run the script:**
    ```bash
    ./install.sh
    ```
4.  **Restart VLC:** Close and reopen VLC Media Player.

## Usage
1.  Open VLC Media Player.
2.  Go to `View > VLC Infinity` in the menu bar.
3.  Select an option from the dialog to browse channels, movies, favorites, or history.

## Troubleshooting
-   If the extension does not appear in the `View` menu, ensure `vlc-infinity.lua` is in the correct `extensions` directory and VLC is restarted.
-   Check VLC's message log (`Tools > Message`) for any errors related to the extension.

## Development
This extension is written in Lua and utilizes VLC's Lua API. Contributions are welcome!

## License
This project is licensed under the MIT License.
