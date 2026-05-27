#!/usr/bin/env sh
# Remove AI Studio app (macOS/Linux) and user config.
set -e

echo '  AI Studio — remove'

case "$(uname -s)" in
  Darwin)
  if [ -d '/Applications/AI Studio.app' ]; then
    rm -rf '/Applications/AI Studio.app'
    echo '  Removed /Applications/AI Studio.app'
  fi
  ;;
  Linux)
  for d in "$HOME/.local/share/ai-studio" "$HOME/.config/ai-studio"; do
    [ -d "$d" ] && rm -rf "$d" && echo "  Removed $d"
  done
  echo '  Remove .deb via: sudo apt remove ai-studio (if installed)'
  ;;
esac

for d in "$HOME/.config/ai-studio"; do
  [ -d "$d" ] && rm -rf "$d" && echo "  Removed $d"
done
