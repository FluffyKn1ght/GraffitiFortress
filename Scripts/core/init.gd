extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var camera: GameCamera = GameCamera.new()
	add_sibling.call_deferred(camera)
	
	queue_free.call_deferred()
