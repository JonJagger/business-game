#!/bin/bash -Ee

export RUBYOPT='-W2'

if [[ ! -f /app/scores/BlueSquare/events.json ]]; then
  echo '[]' > /app/scores/BlueSquare/events.json
fi

if [[ ! -f /app/scores/GreenCircle/events.json ]]; then
  echo '[]' > /app/scores/GreenCircle/events.json
fi

rackup \
  --env production \
  --host 0.0.0.0   \
  --port ${BG_PORT}   \
  --server thin    \
  --warn           \
    config.ru
