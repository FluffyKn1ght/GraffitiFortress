extends CanvasLayer

@onready var label : Label = %label

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_pressed() and (event as InputEventKey).keycode == KEY_F3:
		visible = not visible

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if (!OS.is_debug_build()):
		hide()
		process_mode = Node.PROCESS_MODE_DISABLED


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	label.text = ""
	label.text += "FPS: {0} (vsync={1})".format([Engine.get_frames_per_second(), DisplayServer.window_get_vsync_mode(get_window().get_window_id())])
	label.text += "\nLag: {0}\n_process() delta: {1}".format([60 * delta, delta])
