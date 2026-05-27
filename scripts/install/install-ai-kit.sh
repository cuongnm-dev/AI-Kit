#!/usr/bin/env sh
# Download latest ai-kit bundle from GitHub Releases and install to ~/.ai-kit
set -e

REPO='cuongnm-dev/ai-kit'
API="https://api.github.com/repos/${REPO}/releases/latest"
INSTALL_ROOT="${HOME}/.ai-kit"

echo "  Fetching latest release from ${REPO} ..."
json=$(curl -fsSL -H 'User-Agent: ai-platform-bootstrap' "$API")
url=$(printf '%s' "$json" | grep -o '"browser_download_url": *"[^"]*ai-kit-[^"]*\.tar\.gz"' | head -1 | sed 's/.*: *"\([^"]*\)".*/\1/')
[ -z "$url" ] && url=$(printf '%s' "$json" | grep -o '"browser_download_url": *"[^"]*ai-kit-[^"]*\.zip"' | head -1 | sed 's/.*: *"\([^"]*\)".*/\1/')
[ -z "$url" ] && { echo 'No ai-kit-*.tar.gz or *.zip on latest release.' >&2; exit 1; }

tmp="${TMPDIR:-/tmp}/ai-kit-dl"
rm -rf "$tmp"
mkdir -p "$tmp"
file="$tmp/$(basename "$url" | cut -d'?' -f1)"
curl -fsSL -o "$file" "$url"

work="$tmp/extract"
rm -rf "$work"
mkdir -p "$work"
case "$file" in
  *.tar.gz) tar -xzf "$file" -C "$work" ;;
  *.zip) unzip -q "$file" -d "$work" ;;
esac

if [ -f "$work/install.sh" ]; then
  sh "$work/install.sh"
else
  rm -rf "$INSTALL_ROOT"
  mkdir -p "$INSTALL_ROOT"
  cp -R "$work"/. "$INSTALL_ROOT/"
  bin="${INSTALL_ROOT}/bin"
  case ":$PATH:" in *":$bin:"*) ;; *)
    printf '\n# ai-kit\nexport PATH="%s:$PATH"\n' "$bin" >> "${HOME}/.bashrc" 2>/dev/null || true
    printf '\n# ai-kit\nexport PATH="%s:$PATH"\n' "$bin" >> "${HOME}/.zshrc" 2>/dev/null || true
    echo "  Add to PATH: export PATH=\"$bin:\$PATH\""
  esac
fi

tag=$(printf '%s' "$json" | grep -o '"tag_name": *"[^"]*"' | head -1 | sed 's/.*: *"\([^"]*\)".*/\1/')
echo "  Installed ai-kit ${tag} -> ${INSTALL_ROOT}"
