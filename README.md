# ⚡ Satoshi Maze

Juego de laberintos 2D para Android creado con **Godot 4.7.2**. Incluye **100 laberintos**, controles táctiles, swipe, teclado, efectos neon, partículas, sonidos, cronómetro, movimientos, orbes, estrellas, progreso local y micropagos Lightning.

## Modelo del juego

- Niveles **1, 2 y 3**: gratis.
- Niveles **4 a 100**: **2 sats por laberinto**.
- Lightning Address configurada: **`gastonc@speed.app`**.
- Cada nivel se genera de forma determinística: siempre vuelve a ser el mismo laberinto para ese número de nivel, pero los 100 son diferentes.
- Dificultad progresiva desde 7×7 hasta 25×25 celdas.
- 10 paletas visuales rotativas, glow, fondo animado, trail, partículas y tres orbes por nivel.

## Crear el APK con GitHub Actions

1. Creá un repositorio vacío en GitHub.
2. Copiá todo el contenido de este ZIP a la raíz del repo.
3. Hacé commit y push a `main`.
4. Abrí **Actions → Build Android APK**.
5. Al terminar, descargá el artifact **`SatoshiMaze-Android`**.
6. Dentro vas a encontrar `SatoshiMaze.apk`.

También podés crear un tag como `v1.0.0`. El workflow adjunta automáticamente el APK a una GitHub Release.

El workflow instala JDK 17, Android SDK, Godot 4.7.2 y las export templates correspondientes. El APK de CI se exporta con la firma de debug para que pueda instalarse directamente durante desarrollo.

## Probar localmente

Abrí el proyecto con Godot 4.7.2 y ejecutá `main.tscn`. En escritorio funcionan flechas/WASD y mouse; en Android funcionan swipe y el pad táctil.

## Pagos Lightning

El juego resuelve la Lightning Address mediante LNURL-pay:

1. Consulta `https://speed.app/.well-known/lnurlp/gastonc`.
2. Solicita un invoice de **2000 msats = 2 sats**.
3. Abre el invoice con el esquema Android `lightning:` para que lo tome una wallet instalada.
4. Si la respuesta LNURL contiene una URL `verify`, el juego la consulta periódicamente y desbloquea el nivel al detectar el pago.

### Importante antes de publicar

`AppConfig.ALLOW_MANUAL_PAYMENT_FALLBACK` está en `true` para que el prototipo pueda probarse incluso si el proveedor no devuelve `verify`. En ese caso aparece el botón **“YA PAGUÉ · FALLBACK LOCAL”**. Esto **no es una validación segura**: un usuario puede pulsarlo sin pagar.

Para publicar la monetización en serio, hacé una de estas dos cosas:

- si Speed devuelve `verify` para tu Lightning Address, poné `ALLOW_MANUAL_PAYMENT_FALLBACK := false` y probá pagos reales;
- si no devuelve `verify`, agregá un pequeño backend con la API/webhooks de Speed y desactivá el fallback. **Nunca pongas una secret API key de Speed dentro del APK o en el repositorio.**

Speed documenta eventos como `payment_address.paymentreceived`, webhooks firmados y secret/restricted API keys para implementar esa verificación en servidor.

## Cambiar precio o dirección

Editá `scripts/app_config.gd`:

```gdscript
const PRICE_SATS := 2
const PAYMENT_ADDRESS := "gastonc@speed.app"
```

## Estructura

```text
.
├── .github/workflows/android.yml
├── assets/audio/
├── scripts/
│   ├── app_config.gd
│   ├── backdrop.gd
│   ├── main.gd
│   ├── maze_board.gd
│   ├── maze_generator.gd
│   ├── payment_manager.gd
│   └── save_manager.gd
├── export_presets.cfg
├── icon.svg
├── main.tscn
└── project.godot
```

## Publicación en itch.io

Para pruebas podés subir el APK generado por Actions como archivo descargable. Para actualizaciones públicas estables, usá una keystore de release propia y conservála: Android exige que las futuras actualizaciones estén firmadas con la misma clave.

## Estado

Gameplay, 100 niveles, progreso, UI y build automático: listos. La única parte que requiere validación con tu cuenta real antes de considerar la monetización “producción” es si `gastonc@speed.app` ofrece `verify` en su LNURL-pay. Si no lo ofrece, necesitás el backend/webhook indicado arriba.
