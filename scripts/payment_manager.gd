extends Node
class_name PaymentManager

signal status_changed(text: String)
signal invoice_ready(invoice: String, amount_sats: int, expires_at: int)
signal payment_verified(product_id: String, payment_id: String, amount_sats: int)
signal payment_error(message: String)

var invoice: String = ""
var payment_id: String = ""
var product_id: String = ""
var amount_sats: int = 0
var expires_at: int = 0
var verify_url: String = ""
var callback_url: String = ""
var comment_allowed: int = 0
var _stage: String = ""
var _http: HTTPRequest
var _poll_timer: Timer

func _ready() -> void:
	_http = HTTPRequest.new()
	_http.timeout = 15.0
	_http.body_size_limit = 262144
	add_child(_http)
	_http.request_completed.connect(_on_request_completed)
	_poll_timer = Timer.new()
	_poll_timer.wait_time = AppConfig.PAYMENT_POLL_SECONDS
	_poll_timer.one_shot = false
	add_child(_poll_timer)
	_poll_timer.timeout.connect(check_payment)

func start_purchase(requested_product_id: String) -> void:
	stop_polling()
	_reset_payment_state()
	var product: Dictionary = ProductCatalog.get_product(requested_product_id)
	if product.is_empty():
		payment_error.emit("Producto inválido")
		return
	product_id = requested_product_id
	amount_sats = int(product.get("price_sats", 0))
	if amount_sats <= 0:
		payment_error.emit("Producto inválido")
		return
	_stage = "resolve"
	status_changed.emit("Consultando tu Lightning Address de forma segura…")
	var err: Error = _http.request(AppConfig.LNURL_PAY_ENDPOINT, PackedStringArray(["Accept: application/json"]), HTTPClient.METHOD_GET)
	if err != OK:
		_stage = ""
		payment_error.emit("No se pudo conectar al servicio Lightning")

func open_wallet() -> void:
	# No abrimos una wallet si el invoice no vino acompañado de un mecanismo
	# de verificación. Esto evita pagos que el juego no podría acreditar.
	if invoice.is_empty() or verify_url.is_empty():
		return
	OS.shell_open("lightning:" + invoice)

func copy_invoice() -> void:
	if invoice.is_empty() or verify_url.is_empty():
		return
	DisplayServer.clipboard_set(invoice)
	status_changed.emit("Invoice copiado al portapapeles")

func check_payment() -> void:
	if verify_url.is_empty() or invoice.is_empty() or _stage == "verify":
		return
	if expires_at > 0 and int(Time.get_unix_time_from_system()) >= expires_at:
		stop_polling()
		_stage = ""
		payment_error.emit("El invoice venció. Generá uno nuevo.")
		return
	_stage = "verify"
	var err: Error = _http.request(verify_url, PackedStringArray(["Accept: application/json"]), HTTPClient.METHOD_GET)
	if err != OK:
		_stage = "ready"

func stop_polling() -> void:
	if _poll_timer != null:
		_poll_timer.stop()

func _reset_payment_state() -> void:
	invoice = ""
	payment_id = ""
	product_id = ""
	amount_sats = 0
	expires_at = 0
	verify_url = ""
	callback_url = ""
	comment_allowed = 0
	_stage = ""

func _on_request_completed(result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS or response_code < 200 or response_code >= 300:
		var failed_stage: String = _stage
		_stage = "ready" if failed_stage == "verify" else ""
		if failed_stage == "verify":
			status_changed.emit("Pago todavía no confirmado.")
		else:
			payment_error.emit("No se pudo conectar al servicio Lightning")
		return
	var parsed: Variant = JSON.parse_string(body.get_string_from_utf8())
	if typeof(parsed) != TYPE_DICTIONARY:
		var invalid_stage: String = _stage
		_stage = "ready" if invalid_stage == "verify" else ""
		if invalid_stage == "verify":
			status_changed.emit("Pago todavía no confirmado.")
		else:
			payment_error.emit("Respuesta Lightning inválida")
		return
	var data: Dictionary = parsed
	if str(data.get("status", "")).to_upper() == "ERROR":
		var reason: String = str(data.get("reason", "Respuesta Lightning inválida"))
		var error_stage: String = _stage
		_stage = "ready" if error_stage == "verify" else ""
		if error_stage == "verify":
			status_changed.emit(reason)
		else:
			payment_error.emit(reason)
		return
	match _stage:
		"resolve":
			_handle_pay_request(data)
		"invoice":
			_handle_invoice_response(data)
		"verify":
			_handle_verify_response(data)

func _handle_pay_request(data: Dictionary) -> void:
	if str(data.get("tag", "")) != "payRequest":
		_stage = ""
		payment_error.emit("Respuesta Lightning inválida")
		return
	callback_url = str(data.get("callback", ""))
	if not _is_safe_https_url(callback_url):
		_stage = ""
		payment_error.emit("El callback Lightning no es HTTPS")
		return
	var amount_msats: int = amount_sats * 1000
	var min_sendable: int = int(data.get("minSendable", 0))
	var max_sendable: int = int(data.get("maxSendable", 0))
	if min_sendable <= 0 or max_sendable <= 0 or amount_msats < min_sendable or amount_msats > max_sendable:
		_stage = ""
		payment_error.emit("El importe no está permitido por el receptor")
		return
	comment_allowed = maxi(int(data.get("commentAllowed", 0)), 0)
	var separator: String = "&" if callback_url.contains("?") else "?"
	var request_url: String = callback_url + separator + "amount=" + str(amount_msats)
	if comment_allowed > 0:
		var comment: String = ("Satoshi Maze " + product_id).left(comment_allowed)
		request_url += "&comment=" + comment.uri_encode()
	_stage = "invoice"
	status_changed.emit("Creando invoice Lightning…")
	var err: Error = _http.request(request_url, PackedStringArray(["Accept: application/json"]), HTTPClient.METHOD_GET)
	if err != OK:
		_stage = ""
		payment_error.emit("No se pudo generar el invoice Lightning")

func _handle_invoice_response(data: Dictionary) -> void:
	var returned_invoice: String = str(data.get("pr", ""))
	var returned_verify: String = str(data.get("verify", ""))
	if returned_invoice.is_empty():
		_stage = ""
		payment_error.emit("No se pudo generar el invoice Lightning")
		return
	# LUD-21 `verify` es la única prueba de pago segura que podemos usar sin
	# backend, API key ni webhook. Si no existe, cancelamos ANTES de abrir wallet.
	if returned_verify.is_empty():
		_stage = ""
		invoice = ""
		payment_error.emit("Este receptor no ofrece verificación segura del pago. Compra cancelada: no envíes sats.")
		return
	if not _is_safe_https_url(returned_verify):
		_stage = ""
		invoice = ""
		payment_error.emit("La URL de verificación no es HTTPS")
		return
	invoice = returned_invoice
	verify_url = returned_verify
	payment_id = invoice.sha256_text().substr(0, 32)
	expires_at = int(Time.get_unix_time_from_system()) + AppConfig.PAYMENT_TIMEOUT_SECONDS
	_stage = "ready"
	invoice_ready.emit(invoice, amount_sats, expires_at)
	status_changed.emit("Invoice listo. Esperando pago Lightning…")
	_poll_timer.start()

func _handle_verify_response(data: Dictionary) -> void:
	_stage = "ready"
	var returned_invoice: String = str(data.get("pr", ""))
	if not returned_invoice.is_empty() and returned_invoice != invoice:
		stop_polling()
		_stage = ""
		payment_error.emit("La verificación no corresponde al invoice generado")
		return
	var status: String = str(data.get("status", "")).to_lower()
	var settled: bool = bool(data.get("settled", false)) or bool(data.get("paid", false)) or status in ["paid", "settled", "complete", "completed"]
	if settled:
		stop_polling()
		_stage = ""
		status_changed.emit("¡Pago confirmado!")
		payment_verified.emit(product_id, payment_id, amount_sats)
	else:
		status_changed.emit("Esperando confirmación Lightning…")

func _is_safe_https_url(url: String) -> bool:
	if not url.begins_with("https://"):
		return false
	var rest: String = url.trim_prefix("https://")
	var authority: String = rest.get_slice("/", 0)
	if authority.is_empty() or authority.contains("@"):
		return false
	return true
