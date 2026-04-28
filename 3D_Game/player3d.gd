extends CharacterBody3D

const WALK_SPEED := 7.0
const SPRINT_SPEED := 12.0
const JUMP_VELOCITY := 4.5
const SENSITIVITY := 0.009

const MAX_STAMINA := 100.0
const STAMINA_DRAIN_RATE := 25.0
const STAMINA_RECOVER_RATE := 10.0

var stamina := MAX_STAMINA
var can_sprint := true
var is_dead := false

@onready var pivot: Node3D = $Pivot
@onready var pitch: Node3D = $Pivot/Pitch
@onready var camera: Camera3D = $Pivot/Pitch/Camera3D
@onready var stamina_bar: ProgressBar = $"CanvasLayer/Control/StaminaBar"
@onready var death_fade: ColorRect = $CanvasLayer/DeathFade

func _ready() -> void:
	add_to_group("player")

	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	death_fade.visible = true
	death_fade.color = Color.BLACK
	death_fade.modulate.a = 0.0
	death_fade.mouse_filter = Control.MOUSE_FILTER_IGNORE

	stamina_bar.max_value = MAX_STAMINA
	stamina_bar.value = stamina

func enemy_attack_effect() -> void:
	if is_dead:
		return

	print("PLAYER GOT ATTACKED")

	is_dead = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	death_fade.visible = true
	death_fade.color = Color.BLACK
	death_fade.modulate.a = 0.0

	var tween := create_tween()
	tween.tween_property(death_fade, "modulate:a", 1.0, 1.5)
	tween.finished.connect(change_to_death_screen)

func change_to_death_screen() -> void:
	print("CHANGING TO DEATH SCREEN")
	get_tree().change_scene_to_file("res://deathScreen/death_screen.tscn")

func _unhandled_input(event: InputEvent) -> void:
	if is_dead:
		return

	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		pivot.rotate_y(-event.relative.x * SENSITIVITY)
		pitch.rotate_x(-event.relative.y * SENSITIVITY)
		pitch.rotation.x = clamp(pitch.rotation.x, deg_to_rad(-80), deg_to_rad(80))

	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	if event is InputEventMouseButton and event.pressed:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta: float) -> void:
	if is_dead:
		velocity.x = 0.0
		velocity.z = 0.0
		move_and_slide()
		return

	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_vec := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := (pivot.transform.basis * Vector3(input_vec.x, 0, input_vec.y)).normalized()

	var is_moving := direction != Vector3.ZERO
	var wants_to_sprint := Input.is_action_pressed("sprint") and is_moving
	var is_sprinting := wants_to_sprint and can_sprint and stamina > 0.0

	if is_sprinting:
		stamina -= STAMINA_DRAIN_RATE * delta
		stamina = max(stamina, 0.0)

		if stamina <= 0.0:
			can_sprint = false
	else:
		stamina += STAMINA_RECOVER_RATE * delta
		stamina = min(stamina, MAX_STAMINA)

		if stamina >= 20.0:
			can_sprint = true

	var current_speed := SPRINT_SPEED if is_sprinting else WALK_SPEED

	if is_moving:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = 0.0
		velocity.z = 0.0

	move_and_slide()

	stamina_bar.value = stamina
