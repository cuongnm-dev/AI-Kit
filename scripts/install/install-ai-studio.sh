#!/usr/bin/env sh
# Download latest AI Studio installer from GitHub Releases (macOS / Linux).
set -e

REPO='cuongnm-dev/ai-kit'
API="https://api.github.com/repos/${REPO}/releases/latest"

echo "  Fetching AI Studio from ${REPO} ..."
json=$(curl -fsSL -H 'User-Agent: ai-platform-bootstrap' "$API")

pick_asset() {
  pattern="$1"
  printf '%s' "$json" | grep -o "\"browser_download_url\": *\"[^\"]*${pattern}[^\"]*\"" | head -1 | sed 's/.*: *"\([^"]*\)".*/\1/'
}

url=""
case "$(uname -s)" in
  Darwin)
    url=$(pick_asset 'arm64\.dmg') || url=$(pick_asset '\.dmg')
    ;;
  Linux)
    url=$(pick_asset 'AppImage') || url=$(pick_asset '\.deb')
    ;;
  *)
    echo 'Unsupported OS for install-ai-studio.sh' >&2
    exit 1
    ;;
esac

[ -z "$url" ] && { echo 'No AI Studio installer on latest release.' >&2; exit 1; }

dest="${TMPDIR:-/tmp}/$(basename "$url" | cut -d'?' -f1)"
curl -fsSL -o "$dest" "$url"
chmod +x "$dest" 2>/dev/null || true

case "$dest" in
  *.dmg)
    echo "  Open DMG and drag AI Studio to Applications:"
    open "$dest"
    ;;
  *.AppImage)
    echo "  Run: $dest"
  ;;
  *.deb)
    echo "  Install: sudo dpkg -i \"$dest\""
  ;;
esac

tag=$(printf '%s' "$json" | grep -o '"tag_name": *"[^"]*"' | head -1 | sed 's/.*: *"\([^"]*\)".*/\1/')
echo "  AI Studio ${tag} — artifact: $dest"
