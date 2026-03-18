#!/bin/bash

# Trava para evitar spam de notificações
NOTIFIED=false

while true; do
    # Procura a bateria automaticamente
    BATTERY=$(ls /sys/class/power_supply/ | grep '^BAT' | head -n 1)
    
    # Se não achar bateria (ex: PC de mesa), encerra o script
    if [ -z "$BATTERY" ]; then
        exit 0
    fi

    STATUS=$(cat /sys/class/power_supply/$BATTERY/status)
    CAPACITY=$(cat /sys/class/power_supply/$BATTERY/capacity)

    # Se estiver descarregando E menor ou igual a 20%
    if [ "$STATUS" = "Discharging" ] && [ "$CAPACITY" -le 20 ]; then
        if [ "$NOTIFIED" = false ]; then
            # Envia a notificação crítica do Dunst (com a borda vermelha)
            notify-send -u critical -h string:x-dunst-stack-tag:battery "Bateria Fraca" "Nível em ${CAPACITY}%. Conecte o carregador!"
            NOTIFIED=true
        fi
    else
        # Reseta a trava se você conectar o carregador ou se a carga subir
        if [ "$STATUS" = "Charging" ] || [ "$CAPACITY" -gt 20 ]; then
            NOTIFIED=false
        fi
    fi

    # Pausa de 1 minuto antes de checar de novo
    sleep 60
done
