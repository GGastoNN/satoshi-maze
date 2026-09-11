extends Node
class_name PaymentManager

signal status_changed(text: String)
signal invoice_ready(invoice: String, verify_url: String)
signal payment_verified
signal payment_error(message: String)

var level := 0
var invoice := ""
var verify_url := ""
var _stage := ""
var _http: HTTPRequest
var _poll_timer: Timer

func _ready() -> void:
	_http = HTTPRequest.new()
	add_child(_http)
	_http.request_completed.connect(_on_request_completed)
	_poll_timer = Timer.new()
	_poll_timer.wait_time = 2.0
	_poll_timer.one_shot = false
	add_child(_poll_timer)
	_poll_timer.timeout.connect(check_payment)

func start_purchase(for_level: int) -> void:
	level = for_level
	invoice = ""
	verify_url = ""
	_stage = "lnurl_info"
	status_changed.emit("Preparando invoice Lightning de %d sats…" % AppConfig.PRICE_SATS)
	var parts := AppConfig.PAYMENT_ADDRESS.split("@")
	if parts.size() != 2:
		payment_error.emit("Lightning Address inválida")
		return
	var url := "https://%s/.well-known/lnurlp/%s" % [parts[1], parts[0].uri_encode()]
	var err := _http.request(url)
	if err != OK:
		payment_error.emit("No se pudo consultar la Lightning Address")

func open_wallet() -> void:
	if invoice.is_empty():
		return
	OS.shell_open("lightning:" + invoice)

func copy_invoice() -> void:
	if not invoice.is_empty():
		DisplayServer.clipboard_set(invoice)
		status_changed.emit("Invoice copiada al portapapeles")

func check_payment() -> void:
	if verify_url.is_empty() or _stage == "verify":
		return
	_stage = "verify"
	var err := _http.request(verify_url)
	if err != OK:
		_stage = "ready"

func stop_polling() -> void:
	_poll_timer.stop()

func _on_request_completed(_result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	if response_code < 200 or response_code >= 300:
		_stage = ""
		payment_error.emit("Respuesta de pago HTTP %d" % response_code)
		return
	var text := body.get_string_from_utf8()
	var parsed = JSON.parse_string(text)
	if typeof(parsed) != TYPE_DICTIONARY:
		_stage = ""
		payment_error.emit("El proveedor devolvió una respuesta inválida")
		return
	var data: Dictionary = parsed
	if str(data.get("status", "")).to_upper() == "ERROR":
		_stage = ""
		payment_error.emit(str(data.get("reason", "Error LNURL")))
		return

	if _stage == "lnurl_info":
		var callback := str(data.get("callback", ""))
		var amount_msat := AppConfig.PRICE_SATS * 1000
		var min_send := int(data.get("minSendable", 0))
		var max_send := int(data.get("maxSendable", 9223372036854775807))
		if callback.is_empty() or amount_msat < min_send or amount_msat > max_send:
			_stage = ""
			payment_error.emit("La dirección no acepta exactamente %d sats" % AppConfig.PRICE_SATS)
			return
		var joiner := "&" if callback.contains("?") else "?"
		var callback_url := "%s%samount=%d" % [callback, joiner, amount_msat]
		if int(data.get("commentAllowed", 0)) > 0:
			var comment := (AppConfig.LNURL_COMMENT_PREFIX + " " + str(level)).uri_encode()
			callback_url += "&comment=" + comment
		_stage = "invoice"
		status_changed.emit("Generando invoice…")
		var err := _http.request(callback_url)
		if err != OK:
			payment_error.emit("No se pudo generar el invoice")
		return

	if _stage == "invoice":
		invoice = str(data.get("pr", ""))
		verify_url = str(data.get("verify", ""))
		if invoice.is_empty():
			_stage = ""
			payment_error.emit("El proveedor no devolvió un invoice BOLT11")
			return
		_stage = "ready"
		invoice_ready.emit(invoice, verify_url)
		if not verify_url.is_empty():
			status_changed.emit("Invoice listo. Abrí tu wallet; verificaré el pago automáticamente.")
			_poll_timer.start()
		else:
			status_changed.emit("Invoice listo. El proveedor no expone verificación automática.")
		return

	if _stage == "verify":
		var paid := bool(data.get("settled", false)) or bool(data.get("paid", false)) or bool(data.get("isPaid", false))
		var state := str(data.get("status", "")).to_upper()
		paid = paid or state in ["PAID", "SETTLED", "COMPLETE", "COMPLETED"]
		_stage = "ready"
		if paid:
			_poll_timer.stop()
			status_changed.emit("¡Pago confirmado!")
			payment_verified.emit()
		else:
			status_changed.emit("Esperando confirmación Lightning…")
