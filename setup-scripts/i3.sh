#!/bin/sh
set -e
# Requires Antergos XFCE

echo "Installing Vertex theme..."
yaourt -S --noconfirm vertex-themes

echo "Installing i3 and related software..."
yaourt -S --noconfirm \
    i3-gaps i3status rofi \
    compton nitrogen
    #i3ipc-glib-git \

#yaourt -S --noconfirm  xfce4-multiload-nandhp-plugin-git && {
#  echo "Replacing XFCE WM with i3..."
#  CONF=xfce4-session.xml
#  SRC_FOLDER=/etc/xdg/xfce4/xfconf/xfce-perchannel-xml
#  DEST_FOLDER=$HOME/.config/xfce4/xfconf/xfce-perchannel-xml
#
#  [ -f "$SRC_FOLDER/$CONF" ] || {
#    echo "Missing file '"$SRC_FOLDER/$CONF"'. Exiting."
#    exit 1
#  }
#
#  mkdir -p $DEST_FOLDER
#  cat "$SRC_FOLDER/$CONF" | perl -pe 's|xfwm4|i3|g' > "$DEST_FOLDER/$CONF"
#
#  echo "Removing XFCE desktop..."
#  yaourt -R xfdesktop --noconfirm
#
#  echo "Done."
#}
