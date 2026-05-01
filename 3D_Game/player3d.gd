extends CharacterBody3D

# all importnat player movment stuff
const walkSpeed := 5.0
const sprintSpeed := 9.0
const jumpVelocity := 4.5
const sensitivity := 0.003

# stamina stuff so player cant sprint forever
const maxStamina := 100.0
const staminaDrainRate := 25.0
const staminaRecoverRate := 10.0

# player values
var stamina := maxStamina
var canSprint := true
var isDead := false
var flashlightOn := false

# camera stuff for player looking around
@onready var pivot: Node3D = $Pivot
@onready var pitch: Node3D = $Pivot/Pitch
@onready var camera: Camera3D = $Pivot/Pitch/Camera3D

# ui stuff like stamina and death fade
@onready var staminaBar: ProgressBar = $"CanvasLayer/Control/StaminaBar"
@onready var deathFade: ColorRect = $CanvasLayer/DeathFade

# flashlight attached to camrea
@onready var flashlight: SpotLight3D = $Pivot/Pitch/Camera3D/flashlight
@onready var FlashEffect: TextureButton = $"CanvasLayer/Control/FlashEffect"

# player sound for death walking running and flashlight
@onready var scream: AudioStreamPlayer3D = $scream
@onready var walkSound: AudioStreamPlayer3D = $walk
@onready var runSound: AudioStreamPlayer3D = $run
@onready var flashlightSound: AudioStreamPlayer3D = $flashlight

func _ready() -> void:
	# add player to player group so enemy can find him
	add_to_group("player")
	# captures mouse so camera works like first person
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	# death fade starts and mouse ignore it had issues before this
	deathFade.visible = true
	deathFade.color = Color.BLACK
	deathFade.modulate.a = 0.0
	deathFade.mouse_filter = Control.MOUSE_FILTER_IGNORE

	# setup stamina bar might add other ui cuz assume player dumb
	staminaBar.max_value = maxStamina
	staminaBar.value = stamina
	flashlight.visible = flashlightOn

func updateFlashEffect() -> void:
	if flashlightOn:
		FlashEffect.visible = true
		FlashEffect.modulate.a = 0.18
	else:
		FlashEffect.modulate.a = 0.0
		FlashEffect.visible = false

# enemy calls this when player gets attacked
func enemy_attack_effect():
	if isDead:
		return

	isDead = true
	stopFootsteps()
	scream.play()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	# screen fades black
	deathFade.visible = true
	deathFade.modulate.a = 0.0
	#sound and chnage scene
	var tween := create_tween()
	tween.tween_property(deathFade, "modulate:a", 1.0, 1.5)
	tween.finished.connect(changeToDeathScreen)


# changes to death scene after fade
func changeToDeathScreen() -> void:
	get_tree().change_scene_to_file("res://deathScreen/death_screen.tscn")


func _unhandled_input(event: InputEvent) -> void:
	if isDead:
		return

	# mouse look for first person camrea watch youtve vid for this
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		pivot.rotate_y(-event.relative.x * sensitivity)
		pitch.rotate_x(-event.relative.y * sensitivity)
		pitch.rotation.x = clamp(pitch.rotation.x, deg_to_rad(-80), deg_to_rad(80))

	# escape lets mouse become visable again
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	# clicking screen captures mouse again
	if event is InputEventMouseButton and event.pressed:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#flash light sound click sound
	if event.is_action_pressed("flashlight"):
		flashlightOn = !flashlightOn
		flashlight.visible = flashlightOn

		flashlightSound.stop()
		flashlightSound.pitch_scale = 1.3
		flashlightSound.play()
		updateFlashEffect()


func _physics_process(delta: float) -> void:
	# if player stop movment and sounds stpo
	if isDead:
		velocity.x = 0.0
		velocity.z = 0.0
		stopFootsteps()
		move_and_slide()
		return

	# gravity so player does not float
	if not is_on_floor():
		velocity += get_gravity() * delta

	# jump input (Might remove this jump kinda unessaery and make player move faster)
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jumpVelocity

	# player movment input (See input map)
	var inputVec := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := (pivot.transform.basis * Vector3(inputVec.x, 0, inputVec.y)).normalized()

	# checks if player is moving and trying to sprint
	var isMoving := direction != Vector3.ZERO
	var wantsToSprint := Input.is_action_pressed("sprint") and isMoving
	var isSprinting := wantsToSprint and canSprint and stamina > 0.0

	# sprint stamina drain for bar
	if isSprinting:
		stamina -= staminaDrainRate * delta
		stamina = max(stamina, 0.0)
		if stamina <= 0.0:
			canSprint = false
	else:
		# recover stamina when not sprinting
		stamina += staminaRecoverRate * delta
		stamina = min(stamina, maxStamina)
		if stamina >= 20.0:
			canSprint = true

	# player speed change if sprinting
	var currentSpeed := sprintSpeed if isSprinting else walkSpeed

	#movment to player
	if isMoving:
		velocity.x = direction.x * currentSpeed
		velocity.z = direction.z * currentSpeed
	else:
		velocity.x = 0.0
		velocity.z = 0.0

	move_and_slide()

	# walking or running sounds
	handleFootsteps(isMoving, isSprinting)
	staminaBar.value = stamina

# footstep sounds for walking and running
func handleFootsteps(isMoving: bool, isSprinting: bool) -> void:
	# if player not moving or in air stop sound
	if not isMoving or not is_on_floor():
		stopFootsteps()
		return
	# run sound plays when runnnig
	if isSprinting:
		if walkSound.playing:
			walkSound.stop()
		if not runSound.playing:
			runSound.play()
	else:
		# walk sound plays when not running
		if runSound.playing:
			runSound.stop()

		if not walkSound.playing:
			walkSound.play()

# stops walk and run sound
func stopFootsteps() -> void:
	if walkSound.playing:
		walkSound.stop()
	if runSound.playing:
		runSound.stop()
