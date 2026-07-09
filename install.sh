#!/bin/bash

EXT_NAME="vlc-infinity.lua"

# Determine VLC Lua extensions directory based on OS
if [[ "$OSTYPE" == "linux-gnu" ]]; then
    # Linux
    VLC_LUA_DIR="${HOME}/.local/share/vlc/lua/extensions"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    VLC_LUA_DIR="${HOME}/Library/Application Support/org.videolan.vlc/lua/extensions"
else
    echo "Unsupported OS: ${OSTYPE}. Please refer to the documentation for manual installation."
    exit 1
fi

mkdir -p "${VLC_LUA_DIR}"

cp "${EXT_NAME}" "${VLC_LUA_DIR}/"

echo "VLC Infinity extension installed to ${VLC_LUA_DIR}"
echo "Please restart VLC to activate the extension."
