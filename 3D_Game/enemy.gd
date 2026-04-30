extends CharacterBody3D

# all importnat and demonstartes how enemy behaves
const walkSpeed := 4.0
const runSpeed := 6.0
#maybe mondify
const attackRange := 2.0
const chaseRange := 20.0
# do not chnage this need to make wander distance big or else they won't move much
const wanderRadius := 30.0
const gravity := 9.8

# so enemy tracks player
@export var playerPath: NodePath

# we set player path of enemy to the player
var player: Node3D = null

var wanderTarget: Vector3 = Vector3.ZERO
var wanderTimer := 0.0

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


func _ready():
	randomize()

	if playerPath != NodePath(""):
		player = get_node(playerPath)
	
	# when enemy initilizes in scene begin animation and growl timer
	# also begin wander
	animTree.active = true
	growlTimer.timeout.connect(onGrowlTimerTimeout)
	setNextGrowlTime()
	pickNewWanderTarget()

func _physics_process(delta: float):
	# inpuing gravity
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = 0
	
	#if player not in sight wander
	if player == null:
		wander(delta)
		move_and_slide()
		return
	
	#if player close and can see player then chase
	# so we calculate player distance and enemy vision which is player distance and chase range
	var playerDist := global_position.distance_to(player.global_position)
	var seesPlayer := playerDist <= chaseRange and canSeePlayer()
	
	# decision making of what to do based on player value like if can see or player null
	if playerDist <= attackRange and seesPlayer:
		attackPlayer()
	elif seesPlayer:
		chasePlayer(player.global_position)
	else:
		wander(delta)
	#DO NOT DELETE
	move_and_slide()


func chasePlayer(targetPos: Vector3):
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
	startFootsteps()

	if growlSound.playing:
		growlSound.stop()


func attackPlayer() -> void:
	velocity.x = 0
	velocity.z = 0

	playAnim("Attack")
	stopFootsteps()

	if growlSound.playing:
		growlSound.stop()

	if player and player.has_method("enemy_attack_effect"):
		player.enemy_attack_effect()


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
		stopFootsteps()
		return

	dir = dir.normalized()

	velocity.x = dir.x * walkSpeed
	velocity.z = dir.z * walkSpeed

	look_at(global_position + dir, Vector3.UP)

	playAnim("walking")
	startFootsteps()

# Do not chnage this got from Youtube vid and works rn
func pickNewWanderTarget():
	var randomOffset := Vector3(randf_range(-wanderRadius, wanderRadius),0,randf_range(-wanderRadius, wanderRadius))
	
	# from what i understand we use the nav i input and enemy wanders
	# though nav and stops and wanders again
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
	query.exclude = [self.get_rid()]

	var result := spaceState.intersect_ray(query)

	# checks and if no collsion mean no player so null so no chase
	if result.is_empty():
		return false
	
	# importnat for detetction and player death
	var hit = result.collider

	# returns if player visable or not
	# FIX: also check if ray hit a child of the player like collision
	return hit == player or player.is_ancestor_of(hit)


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
	# if chase stop growl
	if player and global_position.distance_to(player.global_position) <= chaseRange:
		setNextGrowlTime()
		return

	if not growlSound.playing:
		# random growl time
		growlSound.pitch_scale = randf_range(0.9, 1.1)
		growlSound.play()

	setNextGrowlTime()


# for growl timer makes noise between 4 and 10 secs
func setNextGrowlTime():
	growlTimer.wait_time = randf_range(4.0, 10.0)
	growlTimer.start()
