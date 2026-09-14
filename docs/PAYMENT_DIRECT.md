# Pago Lightning directo — Satoshi Maze V3

La V3 usa LNURL-pay directamente desde el APK. No requiere backend de pagos, API keys, webhook ni secretos.

## Flujo seguro

1. El juego toma el precio exclusivamente de `ProductCatalog`.
2. Consulta por HTTPS el endpoint LNURL-pay configurado.
3. Valida `tag=payRequest`, rango `minSendable/maxSendable` y callback HTTPS.
4. Solicita un BOLT11 por el importe exacto en millisatoshis.
5. **Antes de mostrar o abrir el invoice**, exige que la respuesta incluya un `verify` HTTPS (LNURL LUD-21).
6. El juego abre la wallet y consulta `verify` periódicamente.
7. El producto se concede únicamente cuando el endpoint informa que el invoice está `settled/paid`.
8. Si la verificación devuelve un `pr`, debe coincidir exactamente con el invoice generado.

Si el receptor no devuelve `verify`, el cobro se cancela antes de abrir la wallet. No existe botón manual de “ya pagué”.

## Economía de campaña V5.5

Los niveles normales de campaña son gratuitos. Solo los Boss Maze 10, 20, 30, 40, 50, 60, 70, 80, 90 y 100 generan productos de nivel pagables. Sus precios son 10, 12, 14, 16, 18, 20, 22, 24, 28 y 30 sats respectivamente. La compra acredita el Boss, pero el acceso sigue sujeto al progreso secuencial de la campaña.

## Límites de este modo

- Las compras se conservan localmente en el sandbox de la aplicación.
- Sin servidor no existe restauración criptográficamente segura después de borrar datos o cambiar de dispositivo.
- Un dispositivo rooteado o un APK modificado puede alterar datos locales. Ninguna arquitectura puramente cliente puede impedirlo por completo.
- El endpoint LNURL usado por el APK no es secreto: cualquier endpoint de red de una aplicación cliente puede observarse o extraerse del binario.

## Privacidad

La compra directa no envía `install_id`, alias, historial, locale ni estadísticas del jugador. Si LNURL permite comentarios, se usa únicamente un identificador corto del producto.
