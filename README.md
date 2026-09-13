# Satoshi Maze V5.2

Juego de laberintos para Android hecho con Godot 4.7.x, desarrollado por **ILLU ENTERTAINMENT**, con 100 niveles, desafíos Daily/Weekly, Infinite Run, Ghost Run, estrellas, modificadores, cosméticos y tienda Lightning.

## Novedades V5.2

- Intro cinematográfica en dos actos: **ILLU ENTERTAINMENT** → **Satoshi Maze**.
- Fondo procedural con partículas, halos, anillos y trazos de laberinto animados.
- Reveal por capas, destello de transición y entrada escalonada al menú principal.
- Nuevo stinger corto de estudio, sin bloquear el acceso al juego.
- La intro puede saltarse inmediatamente con toque, clic o tecla.
- Taglines de la presentación localizados en los seis idiomas disponibles.

## Novedades V5.1

- Impacto contra paredes reforzado: retroceso, flash localizado, micro-shake, sonido y feedback háptico configurable.
- Permiso Android VIBRATE habilitado para el feedback háptico.
- Ajuste para activar/desactivar vibración de impactos.

## Novedades V5

- Intro animada de **ILLU ENTERTAINMENT** al iniciar el APK, con transición automática y opción de tocar para continuar.
- Branding discreto de ILLU ENTERTAINMENT en el menú principal y en Ajustes.
- Política de Privacidad completa dentro del APK.
- Términos y Condiciones de Uso completos dentro del APK.
- Documentos legales localizados en español, inglés, portugués, francés, alemán e italiano.
- Ajustes convertido a scroll táctil para incorporar idioma, estudio y documentos legales sin perder usabilidad en pantallas pequeñas.
- Se conserva el sistema de scroll táctil V4 en las pantallas existentes.
- Se conserva automáticamente el progreso, compras, récords, idioma y cosméticos de V3/V4.

## Pagos Lightning

Pago directo por LNURL-pay, sin backend de pagos, API keys ni webhook. La acreditación exige el endpoint LNURL `verify`; si no existe verificación segura, el juego cancela antes de abrir la wallet.

Los tres primeros niveles son gratuitos. Los niveles premium y la tienda ofrecen desbloqueos permanentes y cosméticos, sin ventajas pay-to-win. Las compras se guardan localmente en el dispositivo.

Más detalles: `docs/PAYMENT_DIRECT.md`.

## Privacidad y términos

Dentro del juego: **Ajustes → Política de Privacidad** y **Ajustes → Términos y Condiciones**.

La política describe el almacenamiento local de progreso y compras, el identificador aleatorio de instalación, el funcionamiento de los pagos Lightning y el estado opcional del ranking online. No se integran SDKs propios de publicidad ni analítica de terceros en esta versión.

Copias de referencia para publicación web: `docs/PRIVACY_POLICY.md` y `docs/TERMS_OF_USE.md`.

## Idiomas

Idioma automático según `OS.get_locale()`: español, inglés, portugués, francés, alemán e italiano; otros locales usan inglés. También existe selección manual en **Ajustes**. La intro y los documentos legales siguen el idioma activo.

## Android / GitHub Actions

El workflow `.github/workflows/android.yml` instala Godot 4.7.2, Java 17 y Android SDK, importa el proyecto, exporta `build/SatoshiMaze.apk` y publica el APK como artifact de Actions.

El proyecto usa GL Compatibility y compresión ETC2/ASTC para Android.

## Ranking online

Daily y Weekly funcionan sin servidor y guardan las mejores marcas localmente. El leaderboard global está desacoplado de los pagos y permanece desactivado mientras `LEADERBOARD_API_BASE` esté vacío.
