extends CharacterBody3D

# all importnat and demonstartes how enemy behaves
const walkSpeed := 3.0
const runSpeed := 6.0
const attackRange := 2.0
const chaseRange := 20.0
# do not chnage this need to make wander distance big or else they won't move much
const wanderRadius := 30.0
# so they keep trackoing the player even if they go behind a wall
const chaseMemoryTime := 6.0
const gravity := 9.8

# so enemy tracks player
@export var playerPath: NodePath

var player: Node3D = null

var wanderTarget: Vector3 = Vector3.ZERO
var wanderTimer := 0.0

# how long enemy chases needed for chase memory
var chaseTimer := 0.0
var lastSeenPos: Vector3 = Vector3.ZERO

# nav so enemy knows where to move
@onready var navAgent: NavigationAgent3D = $NavigationAgent3D

#sounds I added for enemy spo player know where they r
# used timer for growl 
@onready var growlSound: AudioStreamPlayer3D = $Growl
@onready var footstepSound: AudioStreamPlayer3D = $walking
@onready var growlTimer: Timer = $Timer

# animations made with blender using mixamo
@onready var animTree: AnimationTree = $AnimationTree
@onready var animState = animTree.get("parameters/playback")


func _ready() -> void:
	randomize()

	if playerPath != NodePath(""):
		player = get_node(playerPath)
	animTree.active = true
	growlTimer.timeout.connect(onGrowlTimerTimeout)
	setNextGrowlTime()
	pickNewWanderTarget()


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta

	if player == null:
		wander(delta)
		move_and_slide()
		return

	var playerDist := global_position.distance_to(player.global_position)
	var seesPlayer := playerDist <= chaseRange and canSeePlayer()

	if seesPlayer:
		chaseTimer = chaseMemoryTime
		lastSeenPos = player.global_position
	else:
		chaseTimer -= delta
		
	if playerDist <= attackRange and seesPlayer:
		attackPlayer()
	elif seesPlayer:
		chasePlayer(player.global_position)
	elif chaseTimer > 0:
		chasePlayer(lastSeenPos)
	else:
		wander(delta)

	move_and_slide()


func chasePlayer(targetPos: Vector3) -> void:
	navAgent.target_position = targetPos

	var nextPos := navAgent.get_next_path_position()
	var dir := nextPos - global_position
	dir.y = 0

	if dir.length() < 0.2:
		velocity.x = 0
		velocity.z = 0
		playAnim("idle")
		stopFootsteps()
		return

	dir = dir.normalized()

	velocity.x = dir.x * runSpeed
	velocity.z = dir.z * runSpeed

	look_at(global_position + dir, Vector3.UP)

	playAnim("running")
	stopFootsteps()

	if growlSound.playing:
		growlSound.stop()


func attackPlayer() -> void:
	velocity.x = 0
	velocity.z = 0

	playAnim("Attack")
	stopFootsteps()

	if growlSound.playing:
		growlSound.stop()


func wander(delta: float) -> void:
	if navAgent.is_navigation_finished():
		wanderTimer -= delta

		velocity.x = 0
		velocity.z = 0
		playAnim("idle")
		stopFootsteps()

		if wanderTimer <= 0:
			pickNewWanderTarget()

		return

	var nextPos := navAgent.get_next_path_position()
	var dir := nextPos - global_position
	dir.y = 0

	if dir.length() < 0.1:
		velocity.x = 0
		velocity.z = 0
		return

	dir = dir.normalized()

	velocity.x = dir.x * walkSpeed
	velocity.z = dir.z * walkSpeed

	look_at(global_position + dir, Vector3.UP)

	playAnim("walking")
	startFootsteps()


func pickNewWanderTarget() -> void:
	var randomOffset := Vector3(
		randf_range(-wanderRadius, wanderRadius),
		0,
		randf_range(-wanderRadius, wanderRadius)
	)

	wanderTarget = global_position + randomOffset
	navAgent.target_position = wanderTarget
	wanderTimer = randf_range(1.0, 3.0)

# Got this off a youtube vid and works for now
# kinda confusing
# most importnat func for enemy chase mechanics
# DO NOT CHNAGE THIS WHAT SO EVER
func canSeePlayer() -> bool:
	# if eemy does not see player null
	if player == null:
		return false
	
	# raycast model
	var spaceState := get_world_3d().direct_space_state
	
	# ray connects enemy to player and the head position
	var query := PhysicsRayQueryParameters3D.create(
		global_position + Vector3.UP,
		player.global_position + Vector3.UP
	)
	# excludes enemy and this will cause issue with detection
	query.exclude = [self]
	var result := spaceState.intersect_ray(query)
	# checks and if no collsion mean no player so null so no chase
	if result.is_empty():
		return false
	# returns if player visable or not
	return result.collider == player

# basic audio functions
func startFootsteps():
	if not footstepSound.playing:
		footstepSound.play()

func stopFootsteps():
	if footstepSound.playing:
		footstepSound.stop()

func playAnim(animName: String):
	animState.travel(animName)

func onGrowlTimerTimeout():
	if player and global_position.distance_to(player.global_position) <= chaseRange:
		setNextGrowlTime()
		return

	if not growlSound.playing:
		growlSound.pitch_scale = randf_range(0.9, 1.1)
		growlSound.play()

	setNextGrowlTime()

# for growl timer makes noise between 4 and 10 secs
func setNextGrowlTime():
	growlTimer.wait_time = randf_range(4.0, 10.0)
	growlTimer.start()
