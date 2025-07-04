#!/bin/bash

#COLOR VARIABLES
export RED=$(tput setaf 1)
export GREEN=$(tput setaf 2)
export RESET=$(tput sgr0)

function COMPARE_STRINGS() {
  if [ "${1}" == "${2}" ]
  then
    echo -e "Result: ${GREEN}PASS${RESET}"
  else
    echo -e "Resull: ${RED}FAIL${RESET}"
  fi
}

echo -e "########################################################"
echo -e "\t\tValidation Test"

echo -e "########################################################"
echo -e "\tValidating keyboard layout"
KEYBOARD_LAYOUT=$(gsettings get org.gnome.desktop.input-sources sources)
echo -e "Keyboard layout value: ${KEYBOARD_LAYOUT}"
COMPARE_STRINGS "${KEYBOARD_LAYOUT}" "[('xkb', 'latam')]"

echo -e "########################################################"
echo -e "\tValidating screenlock values"
IDLE_DELAY=$(gsettings get org.gnome.desktop.session idle-delay)
echo -e "Idle delay value: ${IDLE_DELAY}"
COMPARE_STRINGS "${IDLE_DELAY}" "uint32 300"
LOCK_ENABLED=$(gsettings get org.gnome.desktop.screensaver lock-enabled)
echo -e "Lock enabled value: ${LOCK_ENABLED}"
COMPARE_STRINGS "${LOCK_ENABLED}" "true"
IDLE_ACTIVATION_ENABLED=$(gsettings get org.gnome.desktop.screensaver idle-activation-enabled)
echo -e "Idle activation enabled value: ${IDLE_ACTIVATION_ENABLED}"
COMPARE_STRINGS "${IDLE_ACTIVATION_ENABLED}" "true"
LOGOUT_ENABLED=$(gsettings get org.gnome.desktop.screensaver logout-enabled)
echo -e "Logout enabled value: ${LOGOUT_ENABLED}"
COMPARE_STRINGS "${LOGOUT_ENABLED}" "false"
SLEEP_INACTIVE_AC_TYPE=$(gsettings get org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type)
echo -e "Sleep inactive AC type value: ${SLEEP_INACTIVE_AC_TYPE}"
COMPARE_STRINGS "${SLEEP_INACTIVE_AC_TYPE}" "'nothing'"

echo -e "########################################################"
echo -e "\tValidating desktop theme values"
BACKGROUND_PICTURE_FILENAME=$(gsettings get org.gnome.desktop.background picture-uri)
echo -e "Background picture file value: ${BACKGROUND_PICTURE_FILENAME}"
COMPARE_STRINGS "${BACKGROUND_PICTURE_FILENAME}" "'file:///usr/share/backgrounds/linuxero-agrio-wallpaper.jpg'"
BACKGROUND_PICTURE_OPTIONS=$(gsettings get org.gnome.desktop.background picture-options)
echo -e "Background picture options value: ${BACKGROUND_PICTURE_OPTIONS}"
COMPARE_STRINGS "${BACKGROUND_PICTURE_OPTIONS}" "'zoom'"
INTERFACE_THEME=$(gsettings get org.gnome.desktop.interface gtk-theme)
echo -e "Interface theme value: ${INTERFACE_THEME}"
COMPARE_STRINGS "${INTERFACE_THEME}" "'Orchis-Compact'"
INTERFACE_ICON_THEME=$(gsettings get org.gnome.desktop.interface icon-theme)
echo -e "Interface icon theme value: ${INTERFACE_ICON_THEME}"
COMPARE_STRINGS "${INTERFACE_ICON_THEME}" "'Tela'"
CURSOR_THEME=$(gsettings get org.gnome.desktop.interface cursor-theme)
echo -e "Cursor theme value: ${CURSOR_THEME}"
COMPARE_STRINGS "${CURSOR_THEME}" "'Adwaita'"
WM_THEME=$(gsettings get org.gnome.desktop.wm.preferences theme)
echo -e "Window manager theme value: ${WM_THEME}"
COMPARE_STRINGS "${WM_THEME}" "'Orchis-Compact'"
SHELL_THEME=$(gsettings get org.gnome.shell.extensions.user-theme name)
echo -e "Shell manager theme value: ${SHELL_THEME}"
COMPARE_STRINGS "${SHELL_THEME}" "'Orchis-Compact'"
DEFAULT_TERMINAL=$(gsettings get org.gnome.desktop.default-applications.terminal exec)
echo -e "Default terminal value: ${DEFAULT_TERMINAL}"
COMPARE_STRINGS "${DEFAULT_TERMINAL}" "'terminator'"

echo -e "########################################################"
echo -e "\tValidating bootc upgrade timer"
systemctl list-timers bootc-fetch-apply-updates.timer
if [ "${?}" == "0" ]
then
  echo -e "Bootc upgrade timer: ${GREEN}PRESENT${RESET}"
else
  echo -e "Bootc upgrade timer: ${RED}ABSENT${RESET}"
fi

echo -e "########################################################"
echo -e "\tValidating skel files and derectorios"
if [ -d "${HOME}/.oh-my-bash" ]
then
  echo -e "Directory ${HOME}/.oh-my-bash: ${GREEN}PRESENT${RESET}"
else
  echo -e "Directory ${HOME}/.oh-my-bash: ${RED}ABSENT${RESET}"
fi

echo -e "########################################################"
echo -e "\tValidating installed packages and groups"
DE_INSTALLED=$(dnf group info workstation-product | grep Installed | awk '{print $3}')
echo -e "Desktop Environment group installed value: ${DE_INSTALLED}"
COMPARE_STRINGS "${DE_INSTALLED}" "yes"
WEB_EXPLORER_INSTALLED=$(dnf group info firefox | grep Installed | awk '{print $3}')
echo -e "Web explorer group installed value: ${WEB_EXPLORER_INSTALLED}"
COMPARE_STRINGS "${WEB_EXPLORER_INSTALLED}" "yes"
for PACKAGE in qemu-guest-agent nautilus nautilus-extensions gnome-remote-desktop freerdp spice-vdagent spice-webdavd firewalld flatpak fastfetch vim-enhanced terminator git gnome-tweaks gnome-extensions-app gnome-shell-extension-user-theme gnome-shell-extension-dash-to-dock gnome-shell-extension-background-logo
do
  rpm -q ${PACKAGE}
  COMPARE_STRINGS "${?}" "0"
done

echo -e "########################################################"
echo -e "\tValidating systemd units"
for MASKED_SYSTEMD_UNIT in dnf-makecache.timer packagekit.service packagekit-offline-update.service flatpak-add-fedora-repos.service
do
  SYSTEMD_UNIT_IS_ENABLED=$(systemctl is-enabled ${MASKED_SYSTEMD_UNIT})
  echo -e "${MASKED_SYSTEMD_UNIT} systemd unit enabled value: ${SYSTEMD_UNIT_IS_ENABLED}"
  COMPARE_STRINGS "${SYSTEMD_UNIT_IS_ENABLED}" "masked"
done
for ENABLED_SYSTEMD_UNIT in firewalld.service
do
  SYSTEMD_UNIT_IS_ENABLED=$(systemctl is-enabled ${ENABLED_SYSTEMD_UNIT})
  echo -e "${ENABLED_SYSTEMD_UNIT} systemd unit enabled value: ${SYSTEMD_UNIT_IS_ENABLED}"
  COMPARE_STRINGS "${SYSTEMD_UNIT_IS_ENABLED}" "enabled"
done

echo -e "########################################################"
echo -e "\tValidating default systemd target"
SYSTEMD_DEFAULT_TARGET=$(systemctl get-default)
echo -e "systemd default target value: ${SYSTEMD_DEFAULT_TARGET}"
COMPARE_STRINGS "${SYSTEMD_DEFAULT_TARGET}" "graphical.target"

echo -e "########################################################"
echo -e "\tValidating locales"
KEYMAP_LAYOUT=$(grep KEYMAP /etc/vconsole.conf | awk -F '=' '{print $2}')
echo -e "Keymap layout value: ${KEYMAP_LAYOUT}"
COMPARE_STRINGS "${KEYMAP_LAYOUT}" "\"latam\""
CONSOLE_FONT=$(grep FONT /etc/vconsole.conf | awk -F '=' '{print $2}')
echo -e "Console font value: ${CONSOLE_FONT}"
COMPARE_STRINGS "${CONSOLE_FONT}" "\"eurlatgr\""
LANG_LOCALE=$(grep LANG /etc/locale.conf | awk -F '=' '{print $2}')
echo -e "Language value: ${LANG_LOCALE}"
COMPARE_STRINGS "${LANG_LOCALE}" "es_MX.UTF-8"
TIME_ZONE=$(readlink -f /etc/localtime)
echo -e "Time Zone link value: ${TIME_ZONE}"
COMPARE_STRINGS "${TIME_ZONE}" "/usr/share/zoneinfo/America/Mexico_City"
