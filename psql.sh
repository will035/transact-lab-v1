#!/usr/bin/env bash
set -euo pipefail
APP_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
LAB_ROOT="$(cd "$APP_DIR/../.." && pwd)"
export LD_LIBRARY_PATH="$LAB_ROOT/work/pg-runtime/usr/lib/x86_64-linux-gnu${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
exec "$LAB_ROOT/work/pg-runtime/usr/lib/postgresql/18/bin/psql" -h "$LAB_ROOT/work/pg-socket" -p 55432 -U demo -d transact_lab "$@"
