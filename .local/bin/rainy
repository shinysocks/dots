#!/bin/bash
# launch rain world without steam on linux

WORK_DIR="$HOME/.steam/steam/steamapps/common/Rain World"
PROTON="$HOME/.steam/steam/steamapps/common/Proton - Experimental/proton"

export STEAM_COMPAT_DATA_PATH="$HOME/.steam/steam/steamapps/compatdata/312520/pfx"
export STEAM_COMPAT_CLIENT_INSTALL_PATH="$HOME/.steam/root"

(cd "$WORK_DIR" ; "$PROTON" run ./RainWorld.exe &>/dev/null &)
