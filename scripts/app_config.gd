extends RefCounted
class_name AppConfig

const GAME_NAME := "Satoshi Maze"
const VERSION := "5.2.0"
const TOTAL_LEVELS := 100
const FREE_LEVELS := 3
const LEVEL_PRICE_SATS := 2

# Pago directo LNURL-pay. La dirección Lightning no se muestra en la UI.
# No hay API keys, secrets, webhook ni backend de pagos dentro del APK.
# IMPORTANTE: esta URL no es un secreto; cualquier endpoint usado por una app cliente
# puede observarse en tráfico de red o extraerse del APK.
const LNURL_PAY_ENDPOINT := "https://speed.app/.well-known/lnurlp/gastonc"
const PAYMENT_POLL_SECONDS := 2.0
const PAYMENT_TIMEOUT_SECONDS := 600

# Ranking online opcional e independiente de los pagos. Vacío = solo marcas locales.
const LEADERBOARD_API_BASE := ""

const SAVE_PATH := "user://satoshi_maze_save_v3.json"
const PREVIOUS_SAVE_PATH := "user://satoshi_maze_save_v2.json"
const LEGACY_SAVE_PATH := "user://satoshi_maze_save.json"

const DAILY_BASE_LEVEL := 56
const WEEKLY_BASE_LEVEL := 78
const INFINITE_START_LEVEL := 20
