extends Camera3D

class_name GameCamera

# Minimal position difference between camera and target for lerping
const POSITION_LERP_THRESHOLD: float = 0.0125

# Minimal rotation difference between camera and target for lerping
const ROTATION_LERP_THRESHOLD: float = 0.0125

class CameraAxis:
	var x: bool = false
	var y: bool = false
	var z: bool = false
	
	func _init(axis_x: bool, axis_y: bool, axis_z: bool) -> void:
		x = axis_x
		y = axis_y
		z = axis_z
	
	# Copy axes from vec_b to vec_a according to CameraAxis values
	func copy(vec_a: Vector3, vec_b: Vector3) -> Vector3:
		if x: vec_a.x = vec_b.x
		if y: vec_a.y = vec_b.y
		if z: vec_a.z = vec_b.z
		return vec_a
		
		

# Singleton shenanigans
static var camera: GameCamera

# Locks up the caller until the GameCamera.camera gets created. Note that this
# leaves room for game processing to not lock up the entire engine
static func ensure_camera() -> void:
	var tree: SceneTree = (Engine.get_main_loop() as SceneTree)
	while not camera:
		await tree.process_frame

# The target the camera will follow/snap to. A value of null switches the
# camera into "manual control" mode.
var target: Node3D = null

# Which weight value to use when smoothly lerping to the camera target's position
# every frame. A value of 1.0 essentially disables lerping.
var target_lerp_pos_weight: float = 1.0

# Which weight value to use when smoothly lerping to the camera target's rotation
# every frame. A value of 1.0 essentially disables lerping.
var target_lerp_rot_weight: float = 1.0

# Which position axes to copy from the camera target
var target_copy_position: CameraAxis = CameraAxis.new(true, true, true)

# Which rotation axes to copy from the camera target
var target_copy_rotation: CameraAxis = CameraAxis.new(true, true, true)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if camera:
		push_error("GameCamera was already instantiated")
		queue_free.call_deferred()
	
	camera = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not target:
		return
	
	var target_pos: Vector3 = target_copy_position.copy(camera.global_position, target.global_position)
	var target_rot: Vector3 = target_copy_rotation.copy(camera.global_rotation_degrees, target.global_rotation_degrees)

	if abs((camera.global_position - target.global_position).length()) > POSITION_LERP_THRESHOLD:
		camera.global_position = camera.global_position.lerp(target_pos, target_lerp_pos_weight)
	else:
		camera.global_position = target_pos
	
	if abs((camera.global_rotation_degrees - target.global_rotation_degrees).length()) > ROTATION_LERP_THRESHOLD:
		camera.global_rotation_degrees = camera.global_rotation_degrees.lerp(target_rot, target_lerp_rot_weight)
	else:
		camera.global_rotation_degrees = target_rot
