extends CharacterBody2D

const Gravity: int = 1000
const MAX_VEL: int = 600
const flap_speed: int = -500
# need to do more tetsing with vector
const start_pos = Vector2(200, 500)

var flying: bool = false
var falling: bool = false

func _ready():
	reset()

func reset():
	falling = false
	flying = false
	velocity = Vector2.ZERO
	position = start_pos
	set_rotation(0)

#lab 2 functionality. Needs to be better optimized
# func _physics_process(delta):
# 	if flying or falling:
# 		velocity.y += Gravity * delta
# 		if velocity.y > MAX_VEL:
# 			velocity.y = MAX_VEL
# 		if flying:
# 			set_rotation(deg_to_rad(velocity.y * 0.05))
# 			$AnimatedSprite2D.play()
# 		elif falling:
# 			set_rotation(PI / 2)
# 			$AnimatedSprite2D.stop()
# 		move_and_slide()
# 	else:
# 		$AnimatedSprite2D.stop()

# func flap():
# 	velocity.y = flap_speed
