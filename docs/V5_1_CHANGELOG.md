# Satoshi Maze V5.1 — Wall Impact Feedback

## Sensación de choque

- Retroceso visual breve del jugador al intentar atravesar una pared.
- Micro-sacudida amortiguada del tablero.
- Destello localizado sobre el segmento de pared golpeado.
- Partículas de impacto orientadas hacia el interior del laberinto.
- Nuevo efecto de sonido `bump.wav`.
- Vibración háptica breve en Android.

## Accesibilidad y ajustes

- Nuevo control para activar o desactivar el feedback háptico.
- El ajuste se guarda junto al resto de la configuración local.
- Android exporta con el permiso `VIBRATE` habilitado.

## Compatibilidad

- Se conserva el mismo archivo de guardado y se agrega el nuevo campo con valor predeterminado compatible.
- `payment_manager.gd` no fue modificado.
- Compras, progreso, cosméticos, idiomas, intro de ILLU ENTERTAINMENT y documentos legales siguen intactos.
