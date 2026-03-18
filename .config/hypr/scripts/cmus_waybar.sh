#!/bin/bash

# Verifica se o cmus está rodando na memória. Se não, sai silenciosamente.
if ! pgrep -x cmus > /dev/null; then
  echo ""
  exit 0
fi

# Pega o status atual (playing, paused, stopped)
STATUS=$(cmus-remote -Q 2>/dev/null | grep "^status " | cut -d ' ' -f 2)

# Se estiver parado ou vazio, não mostra nada
if [ -z "$STATUS" ] || [ "$STATUS" = "stopped" ]; then
  echo ""
  exit 0
fi

# Pega o caminho do arquivo e extrai apenas o nome final (ex: Aula01-Redes.m4a)
FILE=$(cmus-remote -Q 2>/dev/null | grep "^file " | cut -d ' ' -f 2-)
FILENAME=$(basename "$FILE")

# Formata a saída com o ícone correto
if [ "$STATUS" = "playing" ]; then
  echo "⏸ $FILENAME "
elif [ "$STATUS" = "paused" ]; then
  echo "▶ $FILENAME "
fi
