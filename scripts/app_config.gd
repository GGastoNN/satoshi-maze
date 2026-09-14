extends RefCounted
class_name AppConfig

const GAME_NAME := "Satoshi Maze"
const VERSION := "5.5.0"
const TOTAL_LEVELS := 100

# Solo los Boss Maze de campaña requieren pago. El resto de niveles es gratuito,
# pero el avance es estrictamente secuencial.
const BOSS_PRICES_SATS := {
	10: 10,
	20: 12,
	30: 14,
	40: 16,
	50: 18,
	60: 20,
	70: 22,
	80: 24,
	90: 28,
	100: 30,
}

static func is_boss_level(level: int) -> bool:
	return level >= 10 and level <= TOTAL_LEVELS and level % 10 == 0

static func boss_price_sats(level: int) -> int:
	return int(BOSS_PRICES_SATS.get(level, 0))

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
