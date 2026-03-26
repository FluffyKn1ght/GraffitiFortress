extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await GameCamera.ensure_camera()
	
	GameCamera.camera.target_lerp_pos_weight = 0.75
	GameCamera.camera.target_lerp_rot_weight = 0.75
	GameCamera.camera.target = $CameraTargetA


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_a_pressed() -> void:
	GameCamera.camera.target = $CameraTargetA


func _on_b_pressed() -> void:
	GameCamera.camera.target = $CameraTargetB


func _on_manual_pressed() -> void:
	GameCamera.camera.target = null


func _on_lerp_button_pressed(extra_arg_0: float) -> void:
	GameCamera.camera.target_lerp_pos_weight = extra_arg_0
	GameCamera.camera.target_lerp_rot_weight = extra_arg_0
