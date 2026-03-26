extends CanvasLayer

@onready var label : RichTextLabel = %label

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
	
	label.text += "\n\nCAMERA DEBUG:"
	if GameCamera.camera:
		if GameCamera.camera.target:
			label.text += "\nTarget: {0}".format([GameCamera.camera.target.get_path()])
			label.text += "\n    Pos: {0}".format([GameCamera.camera.target.global_position])
			label.text += "\n    Rot: {0}".format([GameCamera.camera.target.global_rotation_degrees])
		else:
			label.text += "\nTarget: <null>"
			label.text += "\n  <No target - manual control>"
		label.text += "\nLerp Settings:"
		label.text += "\n    Pos Weight: {0}".format([GameCamera.camera.target_lerp_pos_weight])
		label.text += "\n    Rot Weight: {0}".format([GameCamera.camera.target_lerp_rot_weight])
		
		label.text += "\nCamera State:"
		label.text += "\n    Pos: {0}".format([GameCamera.camera.global_position])
		label.text += "\n    Rot: {0}".format([GameCamera.camera.global_rotation_degrees])
	else:
		label.text += "\n\n<GameCamera not created>"
