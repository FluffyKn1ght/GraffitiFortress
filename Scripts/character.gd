extends CharacterBody3D

# A controllable game character
class_name Character

# Represents all possible states a character could be in at a given point in time
enum CharacterState {
	NORMAL,
	DEAD
}

const DEFAULT_FLOOR_PHYMAT: PhysicsMaterial = preload("res://Data/phymat/default.phymat")
const DEFAULT_FLOOR_MATERIAL: StandardMaterial3D = preload("res://Data/material/default.material")
const MIN_DECEL_GROUND_VELOCITY: float = 0.005

# The current state of the character
var current_state: CharacterState:
	set(to):
		_chara_state_changed(current_state, to)
		current_state = to

# Camera lock point of the character
@export var camera_point: Node3D = null
# Dedicated RayCast3D instance to be used for detecting floor materials
@export var floor_raycast: RayCast3D = null

@export_subgroup("Movement")
# Normal (running) movement speed, in meters per second
@export var mvmt_speed_normal: float = 3.0
# Crouching movement speed, in meters per second
@export var mvmt_speed_crouch: float = 1.75
# Jump height, in meters
@export var mvmt_jump_height: float = 1.2
# How much is the character bound by gravity
@export var mvmt_gravity_multi: float = 1.0
# How long it takes for the character to accelerate to mvmt_speed, in seconds
@export var mvmt_acceleration: float = 0.075
# How long it takes for the character to completely stop, in seconds
@export var mvmt_deceleration: float = 0.25

# A "joystick" input that controls the character. This is similar to a thumbstick
# on a controller. Note that Y = Z (forward/backward) and X = X (left/right)
var joystick: Vector2 = Vector2.ZERO
# Makes the character jump on the next frame if set to true
var jump: bool = false
# Whether the character is currently crouching or not
var crouch: bool = false

# Last detected floor physics material
var floor_phymat: PhysicsMaterial = DEFAULT_FLOOR_PHYMAT
# Last detected floor texture material
var floor_material: StandardMaterial3D = DEFAULT_FLOOR_MATERIAL

# The current X/Z velocity of the character - how much they will move on the X
# and Z axes this frame. Note that Y = Z (forward/backward) and X = X (left/right)
var ground_velocity: Vector2 = Vector2.ZERO
# The current Y velocity of the character - how much they will move on the Y axis
# this frame
var air_velocity: float = 0.0

func _physics_process(delta: float) -> void:
	# TODO: Crouching
	
	#region Floor materials
	
	if is_on_floor():
		floor_phymat = null
		floor_material = null
		
		var floor_raycast_collider: Node3D = floor_raycast.get_collider()
		if floor_raycast_collider:
			# If we collide with a StaticBody3D, save its physics material
			if floor_raycast_collider is StaticBody3D:
				floor_phymat = floor_raycast_collider.physics_material_override
			
			# Then, attempt to find the texture material of the surface the character's
			# standing on right now by:
			
			# 1. Checking the children of the floor_collider for a MeshInstance3D
			for child in floor_raycast_collider.get_children(true):
				if child is MeshInstance3D:
					floor_material = child.mesh.surface_get_material(0)
			
			# 2. Checking the siblings of the floor_collider for a MeshInstance3D if 
			# the previous check didn't find a material
			if not floor_material:
				for sibling in floor_raycast_collider.get_parent().get_children(true):
					if sibling is MeshInstance3D:
						floor_material = sibling.mesh.surface_get_material(0)
		
		# If we couldn't find the physics/texture material of the floor, use default
		# materials instead
		if not floor_phymat: floor_phymat = DEFAULT_FLOOR_PHYMAT
		if not floor_material: floor_material = DEFAULT_FLOOR_MATERIAL
	
	#endregion
	
	#region Ground velocity
	
	var norm_joystick: Vector2 = joystick.normalized()
	
	# If joystick is not in the center...
	if norm_joystick.length():
		# Accelerate to the target speed
		
		# Find the amount of acceleration we need to apply this frame
		var accel_amount: float = (mvmt_speed_normal / mvmt_acceleration * floor_phymat.friction) / Global.PHYSICS_FPS
		
		# Apply the acceleration while also limiting total ground velocity
		ground_velocity.y += accel_amount * norm_joystick.y
		ground_velocity.x += accel_amount * norm_joystick.x
	else:
		# Decelerate to a complete stop if we haven't stopped already
		if ground_velocity.length() > MIN_DECEL_GROUND_VELOCITY:
			# Find the amount of deceleration we need to apply this frame
			var decel_amount: float = (mvmt_speed_normal / mvmt_deceleration) / Global.PHYSICS_FPS
			
			# Make sure we don't overshoot and turn into a quartz clock oscillator-
			if ground_velocity.length() - decel_amount <= 0:
				ground_velocity = Vector2.ZERO
			else:
				# Calculate the correct direction to apply deceleration in
				var x_dir: int = -1
				var z_dir: int = -1
				
				if ground_velocity.y < 0: z_dir = 1
				elif ground_velocity.y == 0: z_dir = 0
				
				if ground_velocity.x < 0: x_dir = 1
				elif ground_velocity.x == 0: x_dir = 0
				
				# Apply the deceleration
				ground_velocity.y += decel_amount * floor_phymat.friction * z_dir
				ground_velocity.x += decel_amount * floor_phymat.friction * x_dir
				
		elif ground_velocity.length() < MIN_DECEL_GROUND_VELOCITY:
			ground_velocity = Vector2.ZERO
	# Limit ground velocity
	ground_velocity = ground_velocity.limit_length(mvmt_speed_normal)
	
	#endregion
	
	#region Air velocity
	
	if jump:
		jump = false
		if is_on_floor():
			air_velocity = sqrt(2 * (Global.GRAVITY_STRENGTH * mvmt_gravity_multi) * mvmt_jump_height)
		
	if not is_on_floor():
		air_velocity -= (Global.GRAVITY_STRENGTH * mvmt_gravity_multi) / Global.PHYSICS_FPS
		air_velocity = clampf(air_velocity, -(Global.GRAVITY_STRENGTH * mvmt_gravity_multi), INF)
	else:
		if floor_phymat.bounce and not floor_phymat.absorbent:
			air_velocity = abs(air_velocity) * floor_phymat.bounce
		else:
			air_velocity = clampf(air_velocity, 0, INF)
	
	#endregion
	
	# Update the main CharacterBody3D velocity
	velocity.x = ground_velocity.x
	velocity.z = ground_velocity.y
	velocity.y = air_velocity
	
	# Rotate velocity to match the direction of the character
	velocity *= Basis(Vector3.UP, -global_rotation.y)
	
	move_and_slide()

# Called by the setter of current_state whenever the character state is changed
func _chara_state_changed(old: CharacterState, new: CharacterState) -> void:
	pass
