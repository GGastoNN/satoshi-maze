extends ScrollContainer
class_name TouchScrollContainer

# Scroll táctil pensado para listas con Buttons en Android.
# Los botones usan MOUSE_FILTER_PASS y las capas decorativas IGNORE, por lo que
# ScrollContainer puede diferenciar un tap de un drag con esta zona muerta.
const TOUCH_DEADZONE := 18

func _ready() -> void:
	scroll_deadzone = TOUCH_DEADZONE
	horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	vertical_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
	mouse_filter = Control.MOUSE_FILTER_PASS
