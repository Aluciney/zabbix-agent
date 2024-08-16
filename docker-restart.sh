#!/bin/bash

# Verifica se o nome do container foi passado como parâmetro
if [ -z "$1" ]; then
  echo "Por favor, forneça o nome do container."
  exit 1
fi

TRIGGER_NAME="$1"

CONTAINER=$(echo "$TRIGGER_NAME" | awk -F'/' '{print $2}' | awk -F':' '{print $1}' | xargs)

# Verifica se o container existe
if ! docker ps -a --format '{{.Names}}' | grep -q "^$CONTAINER$"; then
  echo "Container $CONTAINER não encontrado."
  exit 1
fi

# Obtém o estado do container
STATUS=$(docker inspect -f '{{.State.Status}}' $CONTAINER 2>/dev/null)

# Verifica se houve erro ao obter o status
if [ $? -ne 0 ]; then
  echo "Erro ao obter o estado do container $CONTAINER."
  exit 1
fi

# Verifica se o container está no estado 'exited'
if [ "$STATUS" == "exited" ]; then
  # Reinicia o container
  if docker start $CONTAINER > /dev/null 2>&1; then
    echo "Container $CONTAINER reiniciado com sucesso."
  else
    echo "Erro ao reiniciar o container $CONTAINER."
    exit 1
  fi
else
  echo "Container $CONTAINER não está no estado 'exited'. Status atual: $STATUS"
fi
