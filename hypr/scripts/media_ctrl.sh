#!/bin/bash

# Define a cor azul e o tempo da notificação
URGENCY="normal" # 'normal' usa a borda azul que configuramos no dunstrc
TIME="1500"

case "$1" in
    vol-up)
        wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+
        VOL=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2*100)}')
        notify-send -u $URGENCY -t $TIME -h string:x-dunst-stack-tag:vol -h int:value:"$VOL" "Volume" "Increased to ${VOL}%"
        ;;
    vol-down)
        wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
        VOL=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2*100)}')
        notify-send -u $URGENCY -t $TIME -h string:x-dunst-stack-tag:vol -h int:value:"$VOL" "Volume" "Decreased to ${VOL}%"
        ;;
    vol-mute)
        wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
        if wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q "MUTED"; then
            notify-send -u $URGENCY -t $TIME -h string:x-dunst-stack-tag:vol "Audio" "Muted"
        else
            VOL=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2*100)}')
            notify-send -u $URGENCY -t $TIME -h string:x-dunst-stack-tag:vol -h int:value:"$VOL" "Audio" "Unmuted at ${VOL}%"
        fi
        ;;
    mic-mute)
        wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
        notify-send -u $URGENCY -t $TIME -h string:x-dunst-stack-tag:mic "Microphone" "Toggled"
        ;;
    bright-up)
        brightnessctl -e4 -n2 set 1%+
        BR=$(brightnessctl -m | cut -d, -f4 | tr -d %)
        notify-send -u $URGENCY -t $TIME -h string:x-dunst-stack-tag:brightness -h int:value:"$BR" "Brightness" "Increased to ${BR}%"
        ;;
    bright-down)
        brightnessctl -e4 -n2 set 1%-
        BR=$(brightnessctl -m | cut -d, -f4 | tr -d %)
        notify-send -u $URGENCY -t $TIME -h string:x-dunst-stack-tag:brightness -h int:value:"$BR" "Brightness" "Decreased to ${BR}%"
        ;;
esac
