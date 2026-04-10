extends CharacterBody3D

const WALK_SPEED := 7.0
const SPRINT_SPEED := 12.0
const JUMP_VELOCITY := 4.5
const SENSITIVITY := 0.03

const MAX_STAMINA := 100.0
const STAMINA_DRAIN_RATE := 25.0
const STAMINA_RECOVER_RATE := 18.0

var stamina := MAX_STAMINA

@onready var pivot: Node3D = $Pivot
@onready var pitch: Node3D = $Pivot/Pitch
@onready var camera: Camera3D = $Pivot/Pitch/Camera3D

# change this path to wherever your ProgressBar is
@onready var stamina_bar: ProgressBar = $"../CanvasLayer/StaminaBar"

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	if stamina_bar:
		stamina_bar.max_value = MAX_STAMINA
		stamina_bar.value = stamina

func _unhandled_input(event: InputEvent) -> void:
	# Look
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		pivot.rotate_y(-event.relative.x * SENSITIVITY)
		pitch.rotate_x(-event.relative.y * SENSITIVITY)
		pitch.rotation.x = clamp(pitch.rotation.x, deg_to_rad(-80), deg_to_rad(80))

	# Release mouse
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	# Recapture mouse
	if event is InputEventMouseButton and event.pressed:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta: float) -> void:
	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Input
	var input_vec := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := (pivot.transform.basis * Vector3(input_vec.x, 0, input_vec.y)).normalized()

	# Sprint check
	var is_moving := direction != Vector3.ZERO
	var is_sprinting := Input.is_action_pressed("sprint") and is_moving and stamina > 0.0

	var current_speed := WALK_SPEED
	if is_sprinting:
		current_speed = SPRINT_SPEED
		stamina -= STAMINA_DRAIN_RATE * delta
		stamina = max(stamina, 0.0)
	else:
		stamina += STAMINA_RECOVER_RATE * delta
		stamina = min(stamina, MAX_STAMINA)

	# Movement
	if is_moving:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = 0.0
		velocity.z = 0.0

	move_and_slide()

	# Update stamina bar
	if stamina_bar:
		stamina_bar.value = stamina
