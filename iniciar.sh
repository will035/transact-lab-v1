#!/usr/bin/env bash
set -euo pipefail
APP_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
LAB_ROOT="$(cd "$APP_DIR/../.." && pwd)"
export LD_LIBRARY_PATH="$LAB_ROOT/work/pg-runtime/usr/lib/x86_64-linux-gnu${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
PG_BIN="$LAB_ROOT/work/pg-runtime/usr/lib/postgresql/18/bin"
if ! "$PG_BIN/pg_ctl" -D "$LAB_ROOT/work/pg-data" status >/dev/null 2>&1; then
 "$PG_BIN/pg_ctl" -D "$LAB_ROOT/work/pg-data" -l "$LAB_ROOT/work/postgres.log" -o "-p 55432 -k $LAB_ROOT/work/pg-socket -h 127.0.0.1" start
fi
export PGHOST="$LAB_ROOT/work/pg-socket" PGPORT=55432 PGUSER=demo PGDATABASE=transact_lab
if ! curl -fsS http://127.0.0.1:3000/api/state >/dev/null 2>&1; then
 nohup node "$APP_DIR/server.mjs" > "$LAB_ROOT/work/demo.log" 2>&1 &
 echo $! > "$LAB_ROOT/work/demo.pid"
fi
if ! curl -fsS http://127.0.0.1:5050/ >/dev/null 2>&1; then
 nohup "$LAB_ROOT/work/pgadmin-env/bin/pgadmin4" > "$LAB_ROOT/work/pgadmin.log" 2>&1 &
 echo $! > "$LAB_ROOT/work/pgadmin.pid"
fi
for address in http://127.0.0.1:3000/api/state http://127.0.0.1:5050/; do
 ready=false
 for attempt in {1..40}; do
  if curl -fsS "$address" >/dev/null 2>&1; then ready=true; break; fi
  sleep 0.5
 done
 if [ "$ready" = false ]; then
  printf 'No arrancó %s. Revisa los registros en %s/work.\n' "$address" "$LAB_ROOT" >&2
  exit 1
 fi
done
printf 'Demo: http://127.0.0.1:3000\npgAdmin: http://127.0.0.1:5050\nPostgreSQL: puerto 55432\n'
if [ "${1:-}" = "--foreground" ]; then wait; fi
