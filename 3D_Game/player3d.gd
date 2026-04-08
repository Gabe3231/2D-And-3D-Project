extends CharacterBody3D

const SPEED = 7.0
const JUMP_VELOCITY = 4.5

func _physics_process(delta: float) -> void:
	# gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# jump IDK if I'll implment this good practice for actual 3D game
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# movement using my assigned movment
	var input_vec = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	velocity.x = input_vec.x * SPEED
	velocity.z = input_vec.y * SPEED

	move_and_slide()
