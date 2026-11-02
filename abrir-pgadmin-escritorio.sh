#!/usr/bin/env bash
set -euo pipefail
APP_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
LAB_ROOT="$(cd "$APP_DIR/../.." && pwd)"
export LD_LIBRARY_PATH="$LAB_ROOT/work/pg-runtime/usr/lib/x86_64-linux-gnu${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
PG_BIN="$LAB_ROOT/work/pg-runtime/usr/lib/postgresql/18/bin"
if ! "$PG_BIN/pg_ctl" -D "$LAB_ROOT/work/pg-data" status >/dev/null 2>&1; then
 "$PG_BIN/pg_ctl" -D "$LAB_ROOT/work/pg-data" -l "$LAB_ROOT/work/postgres.log" -o "-p 55432 -k $LAB_ROOT/work/pg-socket -h 127.0.0.1" start
fi
cd "$LAB_ROOT/work/pgadmin-desktop"
exec ./usr/pgadmin4/bin/pgadmin4 "$@"
