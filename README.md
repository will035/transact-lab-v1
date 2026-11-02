# Transact Lab — versión 1

Demo educativa en español con Node.js y **PostgreSQL real**, instalada localmente en este equipo Linux. No utiliza una simulación de datos en el navegador.

## Abrir y volver a iniciar

- Web: http://127.0.0.1:3000
- pgAdmin: http://127.0.0.1:5050 — pgAdmin 4 v9.19 instalado y configurado

Para iniciar de nuevo los servicios después de reiniciar el equipo:

```bash
bash /home/will/Documents/Codex/2026-11-01/nec/outputs/transact-lab-v1/iniciar.sh
```

La instalación es de usuario y está contenida en la carpeta de este trabajo. No es un servicio del sistema y no se inicia automáticamente al encender el PC. Conserva tanto `outputs` como `work`: allí están los programas y los datos persistentes.

## Qué probar

1. Transferir $100: Ana pasa de $1,000 a $900 y Luis de $500 a $600. El total sigue siendo $1,500.
2. Activar **Provocar un fallo** y transferir: el descuento se revierte con ROLLBACK y ambos saldos conservan sus valores anteriores.
3. En **El último boleto**, lanzar compras con bloqueo: una conexión compra; la otra espera, lee cero boletos y revierte.
4. Repetir sin bloqueo: ambas conexiones leen un boleto antes de actualizar y registran dos compras. Hay una sobreventa aunque el inventario termine en cero.
5. Recargar la página: los datos y el historial siguen en PostgreSQL.
6. Reiniciar laboratorio: restablece exclusivamente las tablas de práctica de esta demo.

El registro SQL se presenta al finalizar cada operación con tiempos capturados en el servidor; no es una transmisión en vivo. Las carreras usan dos conexiones reales y aislamiento READ COMMITTED. El modo inseguro incluye una barrera deliberada para reproducir siempre la condición de carrera. Los UPDATE siguen adquiriendo sus bloqueos normales: el problema es leer y decidir antes de proteger la fila.

## pgAdmin

Se ejecuta como aplicación local en el navegador. La conexión **Transact Lab · PostgreSQL local** ya está registrada en el grupo **Laboratorio**. Su definición también está en `pgadmin-servidor.json`. Para registrarla manualmente, usa **Register → Server**, nombre `Transact Lab`, y en Connection el socket, puerto, base y usuario indicados abajo. No necesitas una contraseña para la conexión por socket de esta instalación.

En el árbol abre **Databases → transact_lab → Schemas → public → Tables**. Usa **Query Tool** para ejecutar `consultas.sql`.

## Base de datos

- PostgreSQL 18.6
- Base: `transact_lab`
- Usuario local: `demo`
- Puerto: `55432` (no interfiere con el puerto habitual 5432)
- Socket local: `/home/will/Documents/Codex/2026-11-01/nec/work/pg-socket`
- Datos: `/home/will/Documents/Codex/2026-11-01/nec/work/pg-data`

La conexión por socket usa autenticación local de confianza dentro de esta instalación de práctica. Las conexiones TCP requieren contraseña y no se configuró una para el usuario demo; usa el socket indicado. Los servicios escuchan solo en este PC. No es una configuración de producción.

Tablas: `accounts` (saldos en centavos enteros), `inventory`, `purchases` y `experiments`. Abre `consultas.sql` en Query Tool para inspeccionarlas. El historial registra el resultado después de finalizar cada operación; no sustituye un sistema de auditoría transaccional de producción.

## Código y validación

- `server.mjs`: API, transacciones y concurrencia.
- `public/`: interfaz adaptable a distintos tamaños de pantalla.
- `test.mjs`: pruebas contra la base de práctica. Restablece los datos al comenzar y terminar.

```bash
node /home/will/Documents/Codex/2026-11-01/nec/outputs/transact-lab-v1/test.mjs
```

Comprobados: COMMIT, ROLLBACK intencional, fondos insuficientes, una única venta con FOR UPDATE, sobreventa sin protección, historial persistido y reinicio.

El laboratorio usa una base compartida local. Mientras corre un experimento rechaza otro experimento con HTTP 409 para no mezclar pruebas; dentro de una carrera sí hay dos transacciones simultáneas. Esta primera versión no incorpora usuarios, despliegue público ni control de aislamiento configurable.

Referencias oficiales: [Configuración de pgAdmin](https://www.pgadmin.org/docs/pgadmin4/development/config_py.html) y [distribuciones de pgAdmin](https://ftp.postgresql.org/pub/pgadmin/pgadmin4/).

También puedes abrir PostgreSQL en la terminal ejecutando `psql.sh` desde esta carpeta. Para detener los servicios iniciados por el lanzador, ejecuta `detener.sh`; los datos se conservan.
