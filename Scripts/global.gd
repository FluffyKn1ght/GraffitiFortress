extends Node

# Global autoload "glue" node

# Process frames per second
const PROCESS_FPS: int = 60
# Physics frames per second
var PHYSICS_FPS: int = ProjectSettings.get_setting("physics/common/physics_ticks_per_second")

# Camera sensitivity
var camera_sensitivity: float = 0.5

# Whether the mouse CAN be locked to the center of the game window
var can_mouse_lock: bool = false
# Whether the mouse is currently locked to the center of the game window. Has no
# effect is can_mouse_lock is false
var mouse_lock: bool = true
# Whether the Global node finished initializing
var is_ready: bool = false

# Main Camera3D camera instancee
var camera: Camera3D = null
# Local player's Character instance
var local_chara: Character = null

func _ready() -> void:
	# Create the camera
	camera = Camera3D.new()
	camera.fov = 85
	add_child.call_deferred(camera)
	
	# Mark the Global node as initialized
	await get_tree().process_frame
	is_ready = true
	
func _process(delta: float) -> void:
	# Ensure only the global Camera3D is ever active
	camera.make_current()
	
	# Update mouse lock state
	if mouse_lock and can_mouse_lock:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	else:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

# Waits until the Global node is fully initialized
func ensure_ready() -> void:
	while not is_ready:
		await (Engine.get_main_loop() as SceneTree).process_frame
	
