#!/bin/sh
set -e
# Requires Antergos XFCE

echo "Installing lightdm-gtk-greeter..."
yaourt -S --noconfirm lightdm-gtk-greeter lightdm-gtk-greeter-settings && {
  LIGHTDM_CONF=/etc/lightdm/lightdm.conf
  echo "cat '$LIGHTDM_CONF' | perl -pe 's|^\s*greeter-session.*$|greeter-session=lightdm-gtk-greeter|g' > '$LIGHTDM_CONF-2'" | sudo sh
  echo "mv '$LIGHTDM_CONF-2' '$LIGHTDM_CONF'" | sudo sh
}
