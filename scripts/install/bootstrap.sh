#!/usr/bin/env sh
# Install full AI Platform stack (ai-kit CLI + engine-config + MCP via ai-kit).
# Requires: Node.js 18+, Docker, git
set -e

REPO='cuongnm-dev/ai-kit'
INSTALL_ROOT="${HOME}/.ai-kit"

echo ''
echo '  AI Platform — bootstrap (macOS/Linux)'
echo "  Distribution: https://github.com/${REPO}"
echo ''

ROOT="$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)"
LOCAL_ZIP=""
for f in "$ROOT"/release-dist/ai-kit-*.tar.gz "$ROOT"/release-dist/ai-kit-*.zip; do
  [ -f "$f" ] && LOCAL_ZIP="$f" && break
done

if [ -n "$LOCAL_ZIP" ]; then
  echo "  Using local package: $(basename "$LOCAL_ZIP")"
  TMP="${TMPDIR:-/tmp}/ai-kit-bootstrap"
  rm -rf "$TMP"
  mkdir -p "$TMP"
  case "$LOCAL_ZIP" in
    *.tar.gz) tar -xzf "$LOCAL_ZIP" -C "$TMP" ;;
    *.zip) unzip -q "$LOCAL_ZIP" -d "$TMP" ;;
  esac
  sh "$TMP/install.sh"
else
  sh "$(dirname "$0")/install-ai-kit.sh"
fi

export PATH="${INSTALL_ROOT}/bin:${PATH}"
if command -v ai-kit >/dev/null 2>&1; then
  ai-kit update
  ai-kit doctor
else
  echo '  Warning: ai-kit not on PATH. Open a new shell or re-run install-ai-kit.sh' >&2
fi

echo ''
echo '  Optional: install AI Studio — curl -sL .../scripts/install/install-ai-studio.sh | bash'
echo ''
echo '  Done. Next: ai-kit status'
echo ''
