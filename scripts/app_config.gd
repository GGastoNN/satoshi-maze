extends RefCounted
class_name AppConfig

const GAME_NAME := "Satoshi Maze"
const TOTAL_LEVELS := 100
const FREE_LEVELS := 3
const PRICE_SATS := 2
const PAYMENT_ADDRESS := "gastonc@speed.app"

# Producción: si el proveedor LNURL devuelve una URL `verify`, el pago se valida
# automáticamente. Algunos proveedores no la exponen; para que este prototipo
# siga siendo jugable se habilita un fallback manual. Desactívalo antes de
# monetizar en serio si tu proveedor no ofrece `verify`.
const ALLOW_MANUAL_PAYMENT_FALLBACK := true
const LNURL_COMMENT_PREFIX := "Satoshi Maze nivel"

const SAVE_PATH := "user://satoshi_maze_save.json"
const VERSION := "1.0.0"
