extends Node3D

@onready var debug: Label = %debug
@onready var player: CharacterBody3D = $Player
@onready var player_mover: PlayerMover = $Player/PlayerMover

var dist_per_sec: float = 0.0
var old_position: Vector3 = Vector3.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await GameCamera.ensure_camera()
	GameCamera.camera.target = $CameraTarget


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	debug.text = ""
	debug.text += "Player info:"
	debug.text += "\nPosition: {0}".format([player.global_position])
	debug.text += "\nRotation: {0}".format([player.global_rotation_degrees])
	debug.text += "\n\nDist Per Second: {0}m".format([dist_per_sec])
	
	debug.text += "\n\nVelocity: {0}".format([player_mover.velocity])
	debug.text += "\nChara Mvmt Stats:"
	debug.text += "\nSpeed: {0} m/s".format([player_mover.chara_mvmt_stats.speed])
	debug.text += "\nJump Pwr: {0}".format([player_mover.chara_mvmt_stats.jump_power])
	debug.text += "\nGravity Multi: {0}".format([player_mover.chara_mvmt_stats.gravity_multi])


func _on_timer_timeout() -> void:
	dist_per_sec = abs((old_position - player.global_position).length())
	old_position = player.global_position
