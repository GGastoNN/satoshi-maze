# Satoshi Maze 5.6 — Android / Play Store

## Estado

- Niveles 1–100: gratuitos, avance contiguo sin saltos.
- Los resultados se guardan inmediatamente, pero la marca de completado de campaña **solo se confirma** al cerrarse el intersticial (o si no hay anuncio disponible). Se evitan bloqueos en modo offline.
- Banner AdMob inferior permanente y precarga de intersticiales: puente de GDScript en `scripts/ad_manager.gd`.
- Se requiere integrar físicamente el plugin de Android GodotAdMob (no incluido en el ZIP) para mostrar anuncios reales.

## Pasos obligatorios para la publicación

1. Instalar un plugin de AdMob compatible con Godot 4.7 y con el API de `scripts/ad_manager.gd`. Se ha preparado el adaptador para el plugin GodotAdMob de mircea35, pero su compatibilidad con Godot 4.7 debe comprobarse en dispositivo. Requiere Gradle Android export y el SDK de Google Mobile Ads.
2. Instalar `Project > Install Android Build Template` y habilitar el plugin en el preset Android.
3. Registrar la app en AdMob e introducir **App ID** en AndroidManifest según las instrucciones del plugin. Reemplazar ambos IDs de unidad **de prueba** y activar `is_real=true` solo tras validar consentimiento, cuenta AdMob y anuncios.
4. Añadir consentimiento UMP según territorio/edad y actualizar política de privacidad, Play Console Data Safety y declaración «Contiene anuncios».
5. Configurar una clave de firma de lanzamiento privada: nunca subirla al ZIP ni al repositorio. La configuración de `export_presets.cfg` necesita las credenciales de firma, incluyendo `keystore/release`, `keystore/release_user` y `keystore/release_password`, según la versión de Godot.
6. Exportar **release AAB**, verificar en dispositivo con Google Play Internal Testing y comprobar banners e intersticiales, incluidos casos sin red/no fill.

**Nota:** Este ZIP es un proyecto de origen actualizado, **no** un `.aab` ya compilado ni un binario listo para subir a Play Store. El flujo GitHub Actions es una base y requiere completar firma y plugin.
