#!/usr/bin/env bash
# Atalho para o Flutter instalado em C:\tools\flutter (fora do PATH).
set -e
FLUTTER="/c/tools/flutter/bin/flutter"
cd "$(dirname "$0")"

case "${1:-run}" in
  run)     "$FLUTTER" run -d chrome --web-port 8080 ;;
  test)    "$FLUTTER" test ;;
  analyze) "$FLUTTER" analyze ;;
  build)   "$FLUTTER" build web ;;
  *)       "$FLUTTER" "$@" ;;
esac
