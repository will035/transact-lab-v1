#!/usr/bin/env bash
set -euo pipefail
APP_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
LAB_ROOT="$(cd "$APP_DIR/../.." && pwd)"
for service in demo pgadmin; do
 if [ -f "$LAB_ROOT/work/$service.pid" ]; then
  pid="$(cat "$LAB_ROOT/work/$service.pid")"
  args="$(ps -p "$pid" -o args= || true)"
  case "$args" in
   *"$APP_DIR/server.mjs"*|*"$LAB_ROOT/work/pgadmin-env/bin/pgadmin4"*) kill "$pid" || true ;;
  esac
 fi
done
export LD_LIBRARY_PATH="$LAB_ROOT/work/pg-runtime/usr/lib/x86_64-linux-gnu${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
"$LAB_ROOT/work/pg-runtime/usr/lib/postgresql/18/bin/pg_ctl" -D "$LAB_ROOT/work/pg-data" -m fast stop
