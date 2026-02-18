#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
APP_DIR="$ROOT_DIR/apps/miniapp"

if [[ ! -d "$APP_DIR" ]]; then
  echo "[verify] miniapp directory not found: $APP_DIR" >&2
  exit 1
fi

cd "$APP_DIR"

echo "[verify] Step 1/3: flutter analyze"
flutter analyze

echo "[verify] Step 2/3: flutter test"
flutter test

echo "[verify] Step 3/3: flutter build web --release"
flutter build web --release

echo "[verify] Done: all verification steps passed."
