#!/usr/bin/env sh
# Remove AI Platform stack: MCP, ai-kit, AI Studio. Pass --keep-engine to keep ~/.config/ai-engine.
set -e

DIR="$(CDPATH= cd -- "$(dirname "$0")" && pwd)"
YES=0
KEEP_ENGINE=0

for arg in "$@"; do
  case "$arg" in
    -y|--yes) YES=1 ;;
    --keep-engine) KEEP_ENGINE=1 ;;
  esac
done

if [ "$YES" != 1 ]; then
  echo 'Will remove: ai-kit, AI Studio, MCP container'
  [ "$KEEP_ENGINE" != 1 ] && echo '  and ~/.config/ai-engine (use --keep-engine to skip)'
  printf 'Continue? (y/N) '
  read -r ans
  case "$ans" in y|Y) ;; *) exit 0 ;; esac
fi

if command -v docker >/dev/null 2>&1; then
  compose="${HOME}/.ai-kit/mcp/docker-compose.yml"
  [ -f "$compose" ] && docker compose -f "$compose" down 2>/dev/null || true
  docker rm -f ai-mcp 2>/dev/null || true
fi

sh "$DIR/remove-ai-studio.sh"
if [ "$KEEP_ENGINE" = 1 ]; then
  sh "$DIR/remove-ai-kit.sh" --yes
else
  sh "$DIR/remove-ai-kit.sh" --yes --include-engine
fi

echo ''
echo '  remove-all complete.'
