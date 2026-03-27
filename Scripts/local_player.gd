extends Node

# Local player character/camera controller


func _physics_process(delta: float) -> void:
	# TODO: Fix camera clipping
	
	if Global.local_chara:
		Global.local_chara.joystick = Input.get_vector("Left", "Right", "Up", "Down")
		Global.local_chara.jump = Input.is_action_pressed("Jump")
		
		if Global.local_chara.current_state == Character.CharacterState.NORMAL:
			Global.camera.global_position = Global.local_chara.camera_point.global_position
			Global.camera.global_rotation.y = Global.local_chara.camera_point.global_rotation.y
			Global.camera.set_cull_mask_value(2, false)
			Global.can_mouse_lock = true
			
func _unhandled_input(event: InputEvent) -> void:
	if event is not InputEventMouseMotion:
		return
	
	if not Global.local_chara:
		return
	
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		var mouse_move_event: InputEventMouseMotion = (event as InputEventMouseMotion)
		
		var camera_x_rot: float = Global.camera.global_rotation_degrees.x
		camera_x_rot -= mouse_move_event.screen_relative.y * Global.camera_sensitivity
		camera_x_rot = clampf(camera_x_rot, -90, 90)
		
		Global.camera.global_rotation_degrees.x = camera_x_rot
		Global.local_chara.global_rotation_degrees.y -= mouse_move_event.screen_relative.x * Global.camera_sensitivity
	
