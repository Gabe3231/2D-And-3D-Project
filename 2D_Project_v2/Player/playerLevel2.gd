extends CharacterBody2D

# calling required components to be used
var plLaser := preload("res://Laser/laser.tscn")
var pDeathEffect := preload("res://Player/PlayerDeath.tscn")

@onready var firingPosition := $FiringPosition
@onready var fireDelayTimer := $FireDelayTimer
@onready var hud := get_tree().current_scene.get_node("HUD")

@export var life: int = 1
@export var speed: float = 200.0
# 0.1 in game
@export var fireDelay: float = 0.1

# updating hud
func _ready():
	add_to_group("player")
	if hud:
		hud.setLives(life)

var is_dead := false
func _physics_process(_delta):
	var dirVec := Vector2.ZERO
	# movment physics do not chnage
	if Input.is_action_pressed("move_left"):
		dirVec.x = -1
	elif Input.is_action_pressed("move_right"):
		dirVec.x = 1
	if Input.is_action_pressed("move_up"):
		dirVec.y = -1
	elif Input.is_action_pressed("move_down"):
		dirVec.y = 1
	# make sure players cannot move diagnoaly faster than any other movement
	velocity = dirVec.normalized() * speed
	move_and_slide()

func damage(amount: int):
	life -= amount
	if hud:
		hud.setLives(life)
	if life <= 0:
		#troubleshooting some stuff
		print("died")
		die()

# when die go to death screen
func die():
	# die when no life left
	if is_dead:
		return
	is_dead = true
	hide()
	set_physics_process(false)
	set_process(false)
	# death animation spawn and then moves to next scene 1 sec after
	var effect = pDeathEffect.instantiate()
	get_tree().current_scene.add_child(effect)
	effect.global_position = $Sprite2D.global_position
	effect.z_index = 100
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://DeathScreen/death_screen_2.tscn")
