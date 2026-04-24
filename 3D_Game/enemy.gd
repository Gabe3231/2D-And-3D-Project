extends CharacterBody3D

const WALK_SPEED := 5.0
const RUN_SPEED := 8.0
const ATTACK_RANGE := 2.0
const RUN_RANGE := 6.0
const CHASE_RANGE := 20.0

const WANDER_RADIUS := 1000.0
const WANDER_INTERVAL := 3.0

@export var player_path: NodePath

var player: Node3D = null
var wander_timer := 0.0

@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var anim_tree: AnimationTree = $AnimationTree
@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D

func _ready() -> void:
	player = get_node_or_null(player_path) as Node3D
	print("player = ", player)
	print(anim_player.get_animation_list())

	anim_tree.active = false
	set_new_wander_target()

func _physics_process(delta: float) -> void:
	if player == null:
		return

	var dir = player.global_position - global_position
	dir.y = 0
	var dist = dir.length()

	if dist <= ATTACK_RANGE:
		play_anim("Attack")
		velocity.x = 0.0
		velocity.z = 0.0
		face_player()

	elif dist <= RUN_RANGE:
		play_anim("running")
		dir = dir.normalized()
		velocity.x = dir.x * RUN_SPEED
		velocity.z = dir.z * RUN_SPEED
		face_player()

	elif dist <= CHASE_RANGE:
		play_anim("walking")
		dir = dir.normalized()
		velocity.x = dir.x * WALK_SPEED
		velocity.z = dir.z * WALK_SPEED
		face_player()

	else:
		handle_wander(delta)

	velocity.y = 0.0
	move_and_slide()

func handle_wander(delta: float) -> void:
	play_anim("walking")

	wander_timer -= delta

	if wander_timer <= 0.0 or nav_agent.is_navigation_finished():
		wander_timer = WANDER_INTERVAL
		set_new_wander_target()

	var next_pos = nav_agent.get_next_path_position()
	var dir = next_pos - global_position
	dir.y = 0

	if dir.length() > 0.1:
		dir = dir.normalized()
		velocity.x = dir.x * WALK_SPEED
		velocity.z = dir.z * WALK_SPEED
		face_direction(next_pos)
	else:
		velocity.x = 0.0
		velocity.z = 0.0

func set_new_wander_target() -> void:
	var random_offset = Vector3(
		randf_range(-WANDER_RADIUS, WANDER_RADIUS),
		0,
		randf_range(-WANDER_RADIUS, WANDER_RADIUS)
	)

	var target_pos = global_position + random_offset
	nav_agent.target_position = target_pos

func face_player() -> void:
	var target = player.global_position
	target.y = global_position.y
	look_at(target, Vector3.UP)

func face_direction(target_pos: Vector3) -> void:
	var target = target_pos
	target.y = global_position.y
	look_at(target, Vector3.UP)

func play_anim(name: String) -> void:
	if anim_player.has_animation(name):
		if anim_player.current_animation != name:
			anim_player.play(name)
