extends Node

# Player movement controller
class_name PlayerMover

# The character this movement controller will control
@export var target: CharacterBody3D = null

# Per-character movement controller settings.
@export var chara_mvmt_stats: CharacterMovementStats = null

var velocity: Vector3 = Vector3.ZERO

func _physics_process(delta: float) -> void:
	if not target or not chara_mvmt_stats:
		return
	
	var joystick: Vector2 = Input.get_vector("Left", "Right", "Up", "Down").normalized()
	velocity.x = joystick.x * (chara_mvmt_stats.speed / 60)
	velocity.z = joystick.y * (chara_mvmt_stats.speed / 60)
	
	target.position += velocity;
