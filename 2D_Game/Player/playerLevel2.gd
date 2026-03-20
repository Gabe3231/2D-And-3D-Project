extends CharacterBody2D
class_name player

var plLaser := preload("res://Laser/laser.tscn")

@onready var firingPosition := $FiringPosition
@onready var fireDelayTimer := $FireDelayTimer
@onready var hud := get_tree().current_scene.get_node("HUD")

@export var life: int = 3
@export var speed: float = 200.0
@export var fireDelay: float = 0.2

func _physics_process(_delta):
	var dirVec := Vector2.ZERO
	
	# movment physics
	if Input.is_action_pressed("move_left"):
		dirVec.x = -1
	elif Input.is_action_pressed("move_right"):
		dirVec.x = 1

	if Input.is_action_pressed("move_up"):
		dirVec.y = -1
	elif Input.is_action_pressed("move_down"):
		dirVec.y = 1

	velocity = dirVec.normalized() * speed
	move_and_slide()

func damage(amount: int):
	life -= amount
	if hud:
		hud.setLives(life)

	print("Player Life = %s" % life)
	if life <= 0:
		print("Player died")
		die()
		
func die():
	get_tree().change_scene_to_file("res://DeathScreen/DeathScreend.tscn")
