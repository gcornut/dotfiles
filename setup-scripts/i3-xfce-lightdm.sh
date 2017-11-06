#!/bin/sh
set -e
# Requires Antergos XFCE

echo "Installing Vertex theme..."
yaourt -S --noconfirm vertex-themes

echo "Installing i3 and related software..."
yaourt -S --noconfirm \
    i3-gaps i3status rofi \
    #i3ipc-glib-git \
    compton nitrogen

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

echo "Installing lightdm-gtk-greeter..."
yaourt -S --noconfirm lightdm-gtk-greeter lightdm-gtk-greeter-settings && {
  LIGHTDM_CONF=/etc/lightdm/lightdm.conf
  echo "cat '$LIGHTDM_CONF' | perl -pe 's|^\s*greeter-session.*$|greeter-session=lightdm-gtk-greeter|g' > '$LIGHTDM_CONF-2'" | sudo sh
  echo "mv '$LIGHTDM_CONF-2' '$LIGHTDM_CONF'" | sudo sh
}
