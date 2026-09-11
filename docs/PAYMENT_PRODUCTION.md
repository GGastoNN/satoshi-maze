# Verificación de pagos para producción

El APK no debe contener `sk_live_...`, restricted keys con privilegios sensibles ni secrets de webhook.

## Camino recomendado

1. Mantener en el cliente la creación del invoice LNURL mediante el endpoint configurado en `AppConfig`, sin mostrar la dirección de cobro en la interfaz ni en la documentación pública.
2. Si el callback devuelve `verify`, usarlo y desactivar el fallback manual.
3. Si no existe `verify`, usar un backend HTTPS propio y Speed Webhooks.
4. En Speed, suscribirse al evento de recepción de Payment Address y verificar siempre la firma del webhook.
5. El backend debe emitir un token de desbloqueo firmado y específico para dispositivo/nivel, que el APK pueda validar.

Para asociar de forma inequívoca **un pago de 2 sats** con **un nivel y un dispositivo** cuando el proveedor no ofrece `verify`, la solución más sólida es crear desde el backend un recurso de pago único con metadata, en vez de intentar inferir qué pago genérico a la Lightning Address pertenece a qué jugador.

Esto evita que dos usuarios que pagan el mismo importe puedan reclamar el pago del otro.
