# Satoshi Maze V3

Juego de laberintos para Android hecho con Godot 4.7.x, con 100 niveles, desafíos Daily/Weekly, Infinite Run, Ghost Run, estrellas, modificadores, cosméticos y tienda Lightning.

## Novedades V3

- Pago Lightning directo por LNURL-pay, sin backend de pagos, API keys ni webhook.
- Verificación obligatoria mediante LNURL `verify` antes de acreditar cualquier compra.
- Si el receptor no permite verificación segura, el juego cancela el flujo antes de abrir la wallet.
- No existe confirmación manual de pago.
- La dirección de cobro no se muestra en la interfaz del juego.
- Idioma automático según locale del dispositivo: español, inglés, portugués, francés, alemán e italiano; otros locales usan inglés.
- Ajuste manual de idioma con opción `Auto`.
- Migración automática de partidas V2 y de la versión original.

## Monetización

Los tres primeros niveles son gratuitos. Los niveles premium y la tienda ofrecen desbloqueos permanentes y cosméticos, sin ventajas pay-to-win. El precio se resuelve dentro del catálogo del juego y el flujo LNURL solicita exactamente ese importe.

En el modo actual las compras son **locales al dispositivo**. No se ofrece “Restaurar compras” porque sin un servidor no es posible vincular de forma segura un pago antiguo con un producto y otro dispositivo.

Más detalles: `docs/PAYMENT_DIRECT.md`.

## Idiomas

Al iniciar, `Localization` lee `OS.get_locale()`; por ejemplo, `es_AR` selecciona español y `pt_BR` portugués. El usuario puede cambiar el idioma en **Ajustes**. La elección se guarda localmente.

## Android / GitHub Actions

El workflow `.github/workflows/android.yml` instala Godot 4.7.2, Java 17 y Android SDK, importa el proyecto, exporta `build/SatoshiMaze.apk` y publica el APK como artifact de Actions.

El proyecto usa GL Compatibility y compresión ETC2/ASTC para Android.

## Ranking online

Daily y Weekly funcionan sin servidor y guardan las mejores marcas localmente. El leaderboard global está desacoplado de los pagos y permanece desactivado mientras `LEADERBOARD_API_BASE` esté vacío.
