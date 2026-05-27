#!/usr/bin/env bash
# Remove all ai-kit ecosystem products and related global config from Linux/macOS.
# Usage:
#   ./scripts/remove-all-products.sh --dry-run
#   ./scripts/remove-all-products.sh --yes

set -euo pipefail

DRY_RUN=0
YES=0
ROOT_DIR=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run) DRY_RUN=1; shift ;;
    --yes) YES=1; shift ;;
    --root)
      shift
      if [[ $# -eq 0 ]]; then
        echo "Missing value for --root" >&2
        exit 1
      fi
      ROOT_DIR="$1"
      shift
      ;;
    --help|-h)
      cat <<'EOF'
Usage: remove-all-products.sh [--dry-run] [--yes]

Options:
  --dry-run   Show items that would be removed without deleting anything
  --yes       Skip confirmation prompt
EOF
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      exit 1
      ;;
  esac
done

HOME_DIR="${ROOT_DIR:-$HOME}"
OS_NAME="$(uname -s)"

paths=(
  "$HOME_DIR/.ai-kit"
  "$HOME_DIR/.config/opencode/agent"
  "$HOME_DIR/.config/opencode/command"
  "$HOME_DIR/.config/ai-engine"
  "$HOME_DIR/.config/engine"
  "$HOME_DIR/.config/ai-studio"
  "$HOME_DIR/.config/ai-kit"
  "$HOME_DIR/.config/vibe-studio"
  "$HOME_DIR/.local/share/ai-studio"
  "$HOME_DIR/.local/share/ai-kit"
  "$HOME_DIR/.local/share/ai-engine"
  "$HOME_DIR/.local/share/ai-mcp"
  "$HOME_DIR/.local/share/vibe-studio"
  "$HOME_DIR/.cache/ai-studio"
  "$HOME_DIR/.cache/ai-kit"
  "$HOME_DIR/.cache/ai-engine"
  "$HOME_DIR/.cache/ai-mcp"
)

if [[ "$OS_NAME" == "Darwin" ]]; then
  paths+=(
    "/Applications/AI Studio.app"
    "$HOME_DIR/Applications/AI Studio.app"
    "$HOME_DIR/Library/Application Support/AI Studio"
    "$HOME_DIR/Library/Application Support/ai-kit"
    "$HOME_DIR/Library/Application Support/ai-engine"
    "$HOME_DIR/Library/Preferences/com.ai-studio.plist"
    "$HOME_DIR/Library/Preferences/com.ai-kit.plist"
    "$HOME_DIR/Library/Preferences/com.ai-engine.plist"
    "$HOME_DIR/Library/Caches/AI Studio"
    "$HOME_DIR/Library/Caches/ai-kit"
  )
fi

existing=()
shopt -s nullglob
for path in "${paths[@]}"; do
  if [[ "$path" == *'*'* ]]; then
    for expanded in $path; do
      existing+=("$expanded")
    done
  else
    if [[ -e "$path" ]]; then
      existing+=("$path")
    fi
  fi
done
shopt -u nullglob

if [[ ${#existing[@]} -eq 0 ]]; then
  echo "Không tìm thấy đường dẫn cài đặt/config liên quan đến ai-kit/ai-studio/ai-engine/ai-mcp." >&2
  exit 0
fi

echo "Các đường dẫn sẽ bị xoá:"
for path in "${existing[@]}"; do
  echo "  $path"
done

echo
if [[ $DRY_RUN -eq 1 ]]; then
  echo "Dry run: không xoá gì cả."
  exit 0
fi

if [[ $YES -ne 1 ]]; then
  read -rp "Xác nhận xoá toàn bộ các đường dẫn trên? Nhập Y để tiếp tục: " confirm
  if [[ "$confirm" != "Y" && "$confirm" != "y" ]]; then
    echo "Đã huỷ." >&2
    exit 1
  fi
fi

for path in "${existing[@]}"; do
  if [[ "$path" == *'*'* ]]; then
    rm -rf $path || {
      echo "Không thể xoá: $path" >&2
      continue
    }
  else
    if [[ -e "$path" ]]; then
      rm -rf "$path" || {
        echo "Không thể xoá: $path" >&2
        continue
      }
    fi
  fi
  echo "Đã xoá: $path"
done

echo "Đã hoàn tất xóa các sản phẩm và cấu hình toàn cục."