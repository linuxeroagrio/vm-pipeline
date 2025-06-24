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
KEYBOARD_LAYOUT=$(gsettings get org.mate.peripherals-keyboard-xkb.kbd layouts)
echo -e "Keyboard layoiut value: ${KEYBOARD_LAYOUT}"
COMPARE_STRINGS ${KEYBOARD_LAYOUT} "['latam']"

echo -e "########################################################"
echo -e "\tValidating screenlock values"
IDLE_DELAY=$(gsettings get org.mate.session idle-delay)
echo -e "Idle delay value: ${IDLE_DELAY}"
COMPARE_STRINGS ${IDLE_DELAY} "5"
LOCK_DELAY=$(gsettings get org.mate.screensaver lock-delay)
echo -e "Lock delay value: ${LOCK_DELAY}"
COMPARE_STRINGS ${LOCK_DELAY} "0"
LOCK_ENABLED=$(gsettings get org.mate.screensaver lock-enabled)
echo -e "Lock enabled value: ${LOCK_ENABLED}"
COMPARE_STRINGS ${LOCK_ENABLED} "true"
SLEEP_COMPUTER_AC_TIME=$(gsettings get org.mate.power-manager sleep-computer-ac)
echo -e "Sleep computer AC time seconds value: ${SLEEP_COMPUTER_AC_TIME}"
COMPARE_STRINGS ${SLEEP_COMPUTER_AC_TIME} "0"
SLEEP_DISPLAY_AC_TIME=$(gsettings get org.mate.power-manager sleep-display-ac)
echo -e "Sleep display AC time seconds value: ${SLEEP_DISPLAY_AC_TIME}"
COMPARE_STRINGS ${SLEEP_DISPLAY_AC_TIME} "300"
BUTTON_POWER_ACTION=$(gsettings get org.mate.power-manager button-power)
echo -e "Power button action value: ${BUTTON_POWER_ACTION}"
COMPARE_STRINGS ${BUTTON_POWER_ACTION} "'shutdown'"

echo -e "########################################################"
echo -e "\tValidating desktop theme values"
BACKGROUND_PICTURE_FILENAME=$(gsettings get org.mate.background picture-filename)
echo -e "Background picture file value: ${BACKGROUND_PICTURE_FILENAME}"
COMPARE_STRINGS ${BACKGROUND_PICTURE_FILENAME} "'/usr/share/backgrounds/linuxero-agrio-wallpaper.jpg'"
BACKGROUND_PICTURE_OPTIONS=$(gsettings get org.mate.background picture-options)
echo -e "Background picture options value: ${BACKGROUND_PICTURE_OPTIONS}"
COMPARE_STRINGS ${BACKGROUND_PICTURE_OPTIONS} "'zoom'"
INTERFACE_THEME=$(gsettings get org.mate.interface gtk-theme)
echo -e "Interface theme value: ${INTERFACE_THEME}"
COMPARE_STRINGS ${INTERFACE_THEME} "'Mojave-Dark'"
INTERFACE_ICON_THEME=$(gsettings get org.mate.interface icon-theme)
echo -e "Interface icon theme value: ${INTERFACE_ICON_THEME}"
COMPARE_STRINGS ${INTERFACE_ICON_THEME} "'McMojave-circle-dark'"
CURSOR_THEME=$(gsettings get org.mate.peripherals-mouse cursor-theme)
echo -e "Cursor theme value: ${CURSOR_THEME}"
COMPARE_STRINGS ${CURSOR_THEME} "'mate'"
WM_THEME=$(gsettings get org.mate.Marco.general theme)
echo -e "Window manager theme value: ${WM_THEME}"
COMPARE_STRINGS ${WM_THEME} "'Mojave-Dark'"
DEFAULT_TERMINAL=$(gsettings get org.mate.applications-terminal exec)
echo -e "Default terminal value: ${DEFAULT_TERMINAL}"
COMPARE_STRINGS ${DEFAULT_TERMINAL} "'terminator'"
DISPLAYMANAGER_BACKGROUND=$(gsettings get x.dm.slick-greeter background)
echo -e "Display manager background value: ${DISPLAYMANAGER_BACKGROUND}"
COMPARE_STRINGS ${DISPLAYMANAGER_BACKGROUND} "'/usr/share/backgrounds/linuxero-agrio-wallpaper.jpg'"
DISPLAYMANAGER_CURSOR_THEME=$(gsettings get x.dm.slick-greeter cursor-theme-name)
echo -e "Display manager cursor theme value: ${DISPLAYMANAGER_CURSOR_THEME}"
COMPARE_STRINGS ${DISPLAYMANAGER_CURSOR_THEME} "'mate'"
DISPLAYMANAGER_ICON_THEME=$(gsettings get x.dm.slick-greeter icon-theme-name)
echo -e "Display manager icon theme value: ${DISPLAYMANAGER_ICON_THEME}"
COMPARE_STRINGS ${DISPLAYMANAGER_ICON_THEME} "'McMojave-circle-dark'"
DISPLAYMANAGER_THEME=$(gsettings get x.dm.slick-greeter theme-name)
echo -e "Display manager theme value: ${DISPLAYMANAGER_THEME}"
COMPARE_STRINGS ${DISPLAYMANAGER_THEME} "'Mojave-Dark'"

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
echo -e "\tValidating internal certificate"
curl -s https://console-openshift-console.apps.sno.linuxero-agrio.com.mx
if [ "${?}" == "0" ]
then
  echo -e ""
  echo -e "Internal CA: ${GREEN}PRESENT${RESET}"
else
  echo -e ""
  echo -e "Internal CA: ${RED}ABSENT${RESET}"
fi

echo -e "########################################################"
echo -e "\tValidating skel files and derectorios"
if [ -d "${HOME}/.oh-my-bash" ]
then
  echo -e "Directory ${HOME}/.oh-my-bash: ${GREEN}PRESENT${RESET}"
else
  echo -e "Directory ${HOME}/.oh-my-bash: ${RED}ABSENT${RESET}"
fi
for FILE in ${HOME}/.vnc/.de-was-selected ${HOME}/.vnc/kasmvnc.yaml ${HOME}/.vnc/xstartup ${HOME}/.config/systemd/user/kasmvnc@\:1.service
do
  if [ -f "${FILE}" ]
  then
    echo -e "File ${FILE}: ${GREEN}PRESENT${RESET}"
  else
    echo -e "File ${FILE}: ${RED}ABSENT${RESET}"
  fi
done
echo -e "\tValidating installed packages and groups"
DE_INSTALLED=$(dnf group info mate-desktop | grep Installed | awk '{print $3}')
echo -e "Desktop Environment group installed value: ${DE_INSTALLED}"
COMPARE_STRINGS ${DE_INSTALLED} "yes"
for PACKAGE in qemu-guest-agent spice-vdagent spice-webdavd firewalld flatpak fastfetch vim-enhanced terminator git dbus-x11 kasmvncserver
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
