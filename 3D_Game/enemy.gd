extends CharacterBody3D

const SPEED := 5.0
@export var player_path: NodePath
var player: Node3D = null

func _ready() -> void:
	player = get_node(player_path) as Node3D

func _physics_process(delta: float) -> void:
	if player == null:
		return

	if not is_on_floor():
		velocity += get_gravity() * delta

	var direction = player.global_position - global_position
	direction.y = 0

	if direction.length() > 0.1:
		direction = direction.normalized()
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = 0
		velocity.z = 0

	move_and_slide()
