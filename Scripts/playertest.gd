extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await Global.ensure_ready()
	
	Global.camera.global_position = $Camera3D.global_position
	Global.camera.global_rotation = $Camera3D.global_rotation
	Global.local_chara = $TestChara


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
