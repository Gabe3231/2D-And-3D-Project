extends CharacterBody3D

const WALK_SPEED := 4.0
const RUN_SPEED := 6.0
const ATTACK_RANGE := 2.0
const RUN_RANGE := 6.0
const CHASE_RANGE := 20.0

@export var player_path: NodePath

var player: Node3D = null

@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var anim_tree: AnimationTree = $AnimationTree

func _ready() -> void:
	player = get_node_or_null(player_path) as Node3D
	print("player = ", player)
	print(anim_player.get_animation_list())

	anim_tree.active = false

func _physics_process(_delta: float) -> void:
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
		play_anim("idle")
		velocity.x = 0.0
		velocity.z = 0.0

	velocity.y = 0.0
	move_and_slide()

func face_player() -> void:
	var target = player.global_position
	target.y = global_position.y
	look_at(target, Vector3.UP)

func play_anim(name: String) -> void:
	if anim_player.has_animation(name):
		if anim_player.current_animation != name:
			anim_player.play(name)
