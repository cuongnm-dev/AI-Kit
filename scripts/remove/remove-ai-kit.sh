#!/usr/bin/env sh
# Remove ai-kit CLI install (~/.ai-kit). Pass --include-engine to also remove ~/.config/ai-engine.
set -e

KIT_HOME="${HOME}/.ai-kit"
ENGINE_CONFIG="${HOME}/.config/ai-engine"
YES=0
INCLUDE_ENGINE=0

for arg in "$@"; do
  case "$arg" in
    -y|--yes) YES=1 ;;
    --include-engine) INCLUDE_ENGINE=1 ;;
  esac
done

if [ "$YES" != 1 ]; then
  echo 'This removes:'
  echo "  $KIT_HOME"
  [ "$INCLUDE_ENGINE" = 1 ] && echo "  $ENGINE_CONFIG"
  printf 'Continue? (y/N) '
  read -r ans
  case "$ans" in y|Y) ;; *) exit 0 ;; esac
fi

if [ -d "$KIT_HOME" ]; then
  rm -rf "$KIT_HOME"
  echo "  Removed $KIT_HOME"
else
  echo "  Not found: $KIT_HOME"
fi

if [ "$INCLUDE_ENGINE" = 1 ] && [ -d "$ENGINE_CONFIG" ]; then
  rm -rf "$ENGINE_CONFIG"
  echo "  Removed $ENGINE_CONFIG"
fi
