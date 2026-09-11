# Satoshi Maze V4

Juego de laberintos para Android hecho con Godot 4.7.x, con 100 niveles, desafíos Daily/Weekly, Infinite Run, Ghost Run, estrellas, modificadores, cosméticos y tienda Lightning.

## Novedades V4

- Scroll táctil corregido en tienda, campaña, colección y ayuda.
- Las capas visuales de las tarjetas ya no interceptan el gesto; los botones propagan el input al `ScrollContainer`.
- Zona muerta táctil de 18 px para distinguir un tap de un drag y evitar compras/equipados accidentales al desplazar.
- Tienda reorganizada por Destacados, Packs, Skins, Trails, Temas y Efectos de victoria.
- Nuevas skins: Cyber Ruby, Ice Shard, Solar Core y Quantum.
- Nuevos trails: Neon Ribbon, Firefly, Orbit Trail y Glitch Trail.
- Nuevos temas: Arctic, Lava Core, Abyss Ocean y Synthwave.
- Nuevos finales: Thunder Finish, Portal Collapse y Sats Burst.
- Tres packs con precio especial: Neon Starter Pack, Bitcoin Signature y Void Protocol.
- Los packs conceden todos sus cosméticos permanentemente y no ofrecen ventajas competitivas.
- Se conserva automáticamente todo el progreso y las compras de V3.

## Pagos Lightning

Pago directo por LNURL-pay, sin backend de pagos, API keys ni webhook. La acreditación exige el endpoint LNURL `verify`; si no existe verificación segura, el juego cancela antes de abrir la wallet.

Los tres primeros niveles son gratuitos. Los niveles premium y la tienda ofrecen desbloqueos permanentes y cosméticos, sin ventajas pay-to-win. Las compras se guardan localmente en el dispositivo.

Más detalles: `docs/PAYMENT_DIRECT.md`.

## Idiomas

Idioma automático según `OS.get_locale()`: español, inglés, portugués, francés, alemán e italiano; otros locales usan inglés. También existe selección manual en **Ajustes**. Los nuevos productos mantienen traducciones de descripción para los seis idiomas.

## Android / GitHub Actions

El workflow `.github/workflows/android.yml` instala Godot 4.7.2, Java 17 y Android SDK, importa el proyecto, exporta `build/SatoshiMaze.apk` y publica el APK como artifact de Actions.

El proyecto usa GL Compatibility y compresión ETC2/ASTC para Android.

## Ranking online

Daily y Weekly funcionan sin servidor y guardan las mejores marcas localmente. El leaderboard global está desacoplado de los pagos y permanece desactivado mientras `LEADERBOARD_API_BASE` esté vacío.
