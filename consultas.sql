-- En pgAdmin: seleccionar transact_lab y abrir Query Tool.
SELECT id, name, balance / 100.0 AS saldo_mxn FROM accounts ORDER BY id;
SELECT * FROM inventory;
SELECT * FROM purchases ORDER BY id;
SELECT id, kind, result, created_at FROM experiments ORDER BY id DESC;
-- Ver conexiones y esperas mientras corre una carrera protegida.
SELECT pid, state, wait_event_type, wait_event, query
FROM pg_stat_activity WHERE datname = 'transact_lab';
