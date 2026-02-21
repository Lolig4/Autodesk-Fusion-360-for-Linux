#!/usr/bin/env bash

# CONFIGURATION OF THE COLOR SCHEME:
RED=$'\033[0;31m'
YELLOW=$'\033[0;33m'
GREEN=$'\033[0;32m'
NOCOLOR=$'\033[0m'

# Check in which directory the autodesk_fusion_launcher.sh file is located.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Make AUTODESK_ROOT_DIRECTORY absolute (one level up from the script dir)
AUTODESK_ROOT_DIRECTORY="$(cd "$SCRIPT_DIR/.." && pwd)"
WINEPREFIX_LOG_FILE="$AUTODESK_ROOT_DIRECTORY/logs/wineprefixes.log"
if [ ! -f "$WINEPREFIX_LOG_FILE" ]; then
    echo -e "${RED}wineprefixes.log not found at $WINEPREFIX_LOG_FILE. Exiting...${NOCOLOR}"
    exit 1
fi
LOG_AUTODESK_ROOT_DIRECTORY=$(awk 'NR == 2' "$WINEPREFIX_LOG_FILE")
if [ "$AUTODESK_ROOT_DIRECTORY" != "$LOG_AUTODESK_ROOT_DIRECTORY" ]; then
    echo -e "${RED}Error: AUTODESK_ROOT_DIRECTORY does not match wineprefixes.log (line 2). Exiting...${NOCOLOR}"
    exit 1
fi
WINE_PFX=$(awk 'NR == 3' "$WINEPREFIX_LOG_FILE")
PROTON_VERSION=$(awk 'NR == 4' "$WINEPREFIX_LOG_FILE")


PROFILE_DIR_NAME="TSK263CAPMCMN5JT"
if [ "$PROTON_VERSION" != "Wine" ]; then
    USER="steamuser"
fi

# NavToolbar visibility: 1 = True, 0 = False
NAV_TOOLBAR_VISIBLE=0

APPDATA_DIR="$WINE_PFX/drive_c/users/$USER/AppData"
APPLICATION_DATA_DIR="$WINE_PFX/drive_c/users/$USER/Application Data"
TARGET_FILE="NULastDisplayedLayout.xml"

OPTIONS_PATHS=(
    "$APPDATA_DIR/Roaming/Autodesk/Neutron Platform/Options"
    "$APPLICATION_DATA_DIR/Autodesk/Neutron Platform/Options"
    "$APPDATA_DIR/Local/Autodesk/Neutron Platform/Options"
)

PATCHED_COUNT=0
PROFILE_FOUND=0
for options_path in "${OPTIONS_PATHS[@]}"; do
    [ -d "$options_path" ] || continue
    if [[ "$options_path" == *"/Roaming/"* ]]; then
        PATH_LABEL="Roaming"
    elif [[ "$options_path" == *"/Local/"* ]]; then
        PATH_LABEL="Local"
    else
        PATH_LABEL="Application Data"
    fi
    for profile_dir in "$options_path"/*/; do
        [ -d "$profile_dir" ] || continue
        PROFILE_FOUND=1
        dir_name="$(basename "$profile_dir")"
        TARGET="$profile_dir/$TARGET_FILE"
        if [ -f "$TARGET" ]; then
            if (( NAV_TOOLBAR_VISIBLE )); then
                SET_VALUE="True"
                SEARCH_VALUE="False"
            else
                SET_VALUE="False"
                SEARCH_VALUE="True"
            fi
            # Convert UTF-16 to UTF-8 for grep/sed, then convert back
            UTF8_CONTENT=$(iconv -f UTF-16LE -t UTF-8 "$TARGET" 2>/dev/null || cat "$TARGET")
            if echo "$UTF8_CONTENT" | grep -q "Contents=\"NavToolbar\".*Visible=\"$SEARCH_VALUE\""; then
                echo "$UTF8_CONTENT" | sed "s/\(Contents=\"NavToolbar\".*\)Visible=\"$SEARCH_VALUE\"/\1Visible=\"$SET_VALUE\"/" | iconv -f UTF-8 -t UTF-16LE > "$TARGET"
                echo -e "${GREEN}$PATH_LABEL: $dir_name NavToolbar set to $SET_VALUE${NOCOLOR}"
                PATCHED_COUNT=$((PATCHED_COUNT + 1))
            else
                echo -e "${YELLOW}$PATH_LABEL: $dir_name NavToolbar already $SET_VALUE${NOCOLOR}"
            fi
        fi
    done
done

if (( !PROFILE_FOUND )); then
    echo -e "${RED}No profile directories found. Autodesk Fusion needs a logged-in account to apply the fix.${NOCOLOR}"
    exit 1
fi

if (( PATCHED_COUNT == 0 )); then
    echo -e "${RED}No NavToolbar patches applied.${NOCOLOR}"
fi
