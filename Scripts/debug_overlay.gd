extends CanvasLayer

# Debug info overlay

func _unhandled_key_input(event: InputEvent) -> void:
	if (event as InputEventKey).pressed:
		match (event as InputEventKey).keycode:
			KEY_F3:
				%TopLeftLabel.visible = not %TopLeftLabel.visible
			KEY_F4:
				%TopRightLabel.visible = not %TopRightLabel.visible

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not OS.is_debug_build():
		process_mode = Node.PROCESS_MODE_DISABLED
		queue_free.call_deferred()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# WARNING: The following code is an absolute f###ing mess...
	
	%TopRightLabel.text = ""
	
	%TopLeftLabel.text = "FPS: {0}".format([Engine.get_frames_per_second()])
	%TopLeftLabel.text += "\nLag: {0}".format([delta * Global.PROCESS_FPS])
	%TopLeftLabel.text += "\nDelta:\n    Process: {0}\n    Physics: {1}".format([delta, get_physics_process_delta_time()])
	
	if Global.camera:
		%TopLeftLabel.text += "\n\nCamera:\nPosition: {0}\nRotation: {1}\nFOV: {2}".format([Global.camera.global_position, Global.camera.global_rotation_degrees, Global.camera.fov])
	if Global.local_chara:
		%TopRightLabel.text += "Local Character:\n{0}\nPosition: {1}\nRotation: {2}".format([Global.local_chara.get_path(), Global.local_chara.global_position, Global.local_chara.global_rotation_degrees])
		%TopRightLabel.text += "\n\nCamera Point:"
		if Global.local_chara.camera_point:
			%TopRightLabel.text += "\nPosition: {0}\n({1})\nRotation: {2}\n({3})".format([Global.local_chara.camera_point.global_position, Global.local_chara.camera_point.position, Global.local_chara.camera_point.global_rotation_degrees, Global.local_chara.camera_point.rotation_degrees])
		else:
			%TopRightLabel.text += " <null>"
		%TopRightLabel.text += "\n\nState: {0} ({1})".format([Global.local_chara.CharacterState.keys()[Global.local_chara.current_state], Global.local_chara.current_state])
		%TopRightLabel.text += "\n\nMovement:\nInputs: joy={0} jmp={1} cro={2}\nGround Vel: {3}\nAir Vel: {4}\nTOTAL VEL: {5}".format([Global.local_chara.joystick, Global.local_chara.jump, Global.local_chara.crouch, Global.local_chara.ground_velocity, Global.local_chara.air_velocity, Global.local_chara.velocity])
