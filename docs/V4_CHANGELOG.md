# Satoshi Maze V4 — Touch & Store

## Scroll táctil

- Todos los `ScrollContainer` dinámicos de campaña, tienda, colección y ayuda usan `TouchScrollContainer`.
- `scroll_deadzone = 18` para separar tap y drag en Android.
- Los paneles, márgenes, labels y capas decorativas usan `MOUSE_FILTER_IGNORE`.
- Los botones usan `MOUSE_FILTER_PASS`, mantienen tap normal y dejan que el gesto llegue al contenedor.
- El scroll horizontal está desactivado en estas listas para evitar desplazamientos laterales accidentales.

## Tienda

31 productos visibles en total, organizados por filtros y secciones.

Nuevos productos:
- 3 packs: Neon Starter Pack, Bitcoin Signature, Void Protocol.
- 4 skins: Cyber Ruby, Ice Shard, Solar Core, Quantum.
- 4 trails: Neon Ribbon, Firefly, Orbit Trail, Glitch Trail.
- 4 themes: Arctic, Lava Core, Abyss Ocean, Synthwave.
- 3 victory effects: Thunder Finish, Portal Collapse, Sats Burst.

Los packs conceden sus productos hijos en una sola compra y se consideran adquiridos si el jugador ya posee todos sus componentes.

## Compatibilidad

Se mantiene `user://satoshi_maze_save_v3.json`, por lo que progreso, récords, idioma, compras y cosméticos existentes continúan sin migración manual.
