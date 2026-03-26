extends Resource

# Stores character movement settings
class_name CharacterMovementStats

# Character movement speed (in meters per second)
@export var speed: float = 2.0

# Character jump power (set to 0.0 to disable jumping)
@export var jump_power: float = 0.0

# Character gravity multiplier
@export var gravity_multi: float = 1.0
