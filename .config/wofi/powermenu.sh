#!/bin/bash

opcoes="Shutdown\nRestart\nSuspend\nLock\nExit Hyprland"

# Abre o wofi em modo dmenu e guarda a escolha
escolha=$(echo -e "$opcoes" | wofi --dmenu --width 250 --height 210 --prompt "System:")

# Executa o comando de acordo com a escolha
case "$escolha" in
    "Shutdown") systemctl poweroff ;;
    "Restart") systemctl reboot ;;
    "Suspend") systemctl suspend & ;;
    "Lock") loginctl lock-session ;;
    "Exit Hyprland") hyprctl dispatch exit ;;
esac
