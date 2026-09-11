# Satoshi Maze V5 · Visual Edition

Juego de laberintos para Android hecho con Godot 4.7.x. Incluye 100 niveles, Daily Maze, Weekly Speedrun, Infinite Run, Ghost Run, estrellas, Boss Mazes, modificadores, colección cosmética y pagos Lightning directos.

## V5 · Visual Polish

- Diez mundos visuales para la campaña, con fondos y ambientación propios.
- Home renovada con un mini laberinto animado y contexto del mundo actual.
- Movimiento del jugador interpolado, iluminación reactiva y feedback visual al chocar.
- Portales animados, niebla con memoria de zonas exploradas y minimapa opcional para laberintos grandes.
- Resultados con revelado progresivo de estrellas, barra de eficiencia, medallas, récord personal y celebración al cerrar un mundo.
- Colección convertida en galería con previews, bloqueados visibles, rarezas y estado equipado.
- Tienda con previews animados, filtros táctiles y una nueva categoría de Auras.
- Nuevas Auras: Lightning Aura, Quantum Aura, Sats Halo y Prism Aura.
- Nuevo Quantum Motion Pack y Master Crown desbloqueable con 200 estrellas.
- Microanimaciones en botones y transiciones entre pantallas.
- Ajustes de Reduced Motion y minimapa.
- Previews de tienda limitados a 24 FPS y redibujados solo cuando intersectan el viewport para cuidar rendimiento móvil.
- Se mantiene el scroll táctil corregido de V4 en tienda, campaña, colección, ayuda y ajustes.

## Pagos Lightning

El flujo de pagos permanece idéntico al de V4: pago directo por LNURL-pay, sin backend de pagos, API keys ni webhook. El contenido se acredita únicamente mediante la verificación segura del invoice ofrecida por el proveedor. Si no existe verificación, el juego bloquea el cobro antes de abrir la wallet.

Los tres primeros niveles son gratuitos. Los niveles premium, cosméticos y packs son compras permanentes sin ventajas pay-to-win. Las compras se guardan localmente en el dispositivo.

Más detalles: `docs/PAYMENT_DIRECT.md`.

## Idiomas

Detección automática según el locale del dispositivo: español, inglés, portugués, francés, alemán e italiano. Otros locales usan inglés. También existe selección manual en **Ajustes**. Las incorporaciones de V5 respetan el mismo sistema multilenguaje.

## Guardado

V5 conserva `user://satoshi_maze_save_v3.json`, por lo que actualiza sobre V3/V4 sin resetear progreso, estrellas, récords, idioma, niveles comprados ni cosméticos. Los nuevos ajustes usan valores seguros por defecto.

## Android / GitHub Actions

El workflow `.github/workflows/android.yml` usa Godot 4.7.2, Java 17 y Android SDK. Antes de exportar valida la importación y falla si Godot informa `SCRIPT ERROR`, `Parse Error` o scripts que no pudieron cargarse. Luego exporta `build/SatoshiMaze.apk` y lo publica como artifact de Actions.

El proyecto usa GL Compatibility y compresión ETC2/ASTC para Android.
