#!/bin/bash

DIR="$HOME/wallpapers"
ESCOLHA=$(ls "$DIR" | wofi --dmenu --width 400 --height 350 --prompt "Wallpaper:")

if [ -n "$ESCOLHA" ]; then
    CAMINHO_COMPLETO="$DIR/$ESCOLHA"
    CONF_FILE="$HOME/.config/hypr/hyprpaper.conf"
    
    # 1. Reescreve o arquivo (alinhado totalmente à esquerda)
    cat <<EOF > "$CONF_FILE"
preload = $CAMINHO_COMPLETO

wallpaper {
    monitor = eDP-1
    path = $CAMINHO_COMPLETO
    fit_mode = cover
}

ipc = on
splash = false
EOF

    # 2. Aplica a mudança
    if ! pgrep -x "hyprpaper" > /dev/null; then
        # Se estiver fechado, ele abre com a nova configuração
        uwsm app -- hyprpaper &
    else
        # Precarrega a nova imagem
        hyprctl hyprpaper preload "$CAMINHO_COMPLETO"
        
        # Aplica no monitor específico
        hyprctl hyprpaper wallpaper "eDP-1,$CAMINHO_COMPLETO"
        
        # Remove a imagem antiga da RAM para não vazar memória
        hyprctl hyprpaper unload unused
    fi
fi
