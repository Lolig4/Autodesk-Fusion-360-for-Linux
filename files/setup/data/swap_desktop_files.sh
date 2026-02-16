#!/usr/bin/env bash
DESKTOP_DIR="$HOME/.local/share/applications/wine/Programs/Autodesk"

swap_desktop() {
    local FILE="$1"
    FILE_PATH="$DESKTOP_DIR/$FILE"
    mv "$FILE_PATH" "$FILE_PATH.bak2"
    mv "$FILE_PATH.bak" "$FILE_PATH"
    mv "$FILE_PATH.bak2" "$FILE_PATH.bak"
}

swap_desktop "Autodesk Fusion.desktop"
swap_desktop "adskidmgr-opener.desktop"

EXEC_LINE=$(grep -m1 '^Exec=' "$DESKTOP_DIR/adskidmgr-opener.desktop" || true)
if [[ "$EXEC_LINE" == *proton* ]]; then
    echo "proton"
elif [[ "$EXEC_LINE" == *wine* ]]; then
    echo "wine"
else
    echo "unknown"
fi