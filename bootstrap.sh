#!/usr/bin/env sh
# AI Platform — bootstrap (macOS / Linux)
# Entry point at repo root for: curl -sL .../bootstrap.sh | bash
set -e
ROOT="$(CDPATH= cd -- "$(dirname "$0")" && pwd)"
INSTALL="$ROOT/scripts/install/bootstrap.sh"
if [ ! -f "$INSTALL" ]; then
  echo "Missing $INSTALL — sync scripts from the distribution repo." >&2
  exit 1
fi
exec sh "$INSTALL" "$@"
