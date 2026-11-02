#!/usr/bin/env bash
set -euo pipefail
if [ "$EUID" -ne 0 ]; then
 echo 'Ejecuta este archivo con sudo para instalar el perfil de escritorio de pgAdmin.' >&2
 exit 1
fi
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PROFILE=/etc/apparmor.d/pgadmin4-transact-lab
if [ -e "$PROFILE" ] && ! cmp -s "$SCRIPT_DIR/pgadmin4-transact.apparmor" "$PROFILE"; then
 echo "El perfil $PROFILE ya existe con otra configuración. No se modificó." >&2
 exit 1
fi
install -o root -g root -m 644 "$SCRIPT_DIR/pgadmin4-transact.apparmor" "$PROFILE"
/usr/sbin/apparmor_parser -r "$PROFILE"
echo 'Perfil instalado. Abre pgAdmin 4 desde el menú de aplicaciones de Ubuntu (sin sudo).'
