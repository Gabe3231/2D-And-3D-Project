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

# check
var is_dead := false

# updating hud
func _ready():
	add_to_group("player")
	if hud:
		hud.setLives(life)

func _process(_delta):
	# shooting is allowed at 0.1 delay
	if Input.is_action_just_pressed("shoot") and fireDelayTimer.is_stopped():
		fireDelayTimer.start(fireDelay)
		#laser is set on player
		for weapon in firingPosition.get_children():
			var laser = plLaser.instantiate()
			laser.global_position = weapon.global_position
			get_tree().current_scene.add_child(laser)

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
	# make sure players cannot move diagnoaly faster than any other movement
	velocity = dirVec.normalized() * speed
	# collision phsyics
	move_and_slide()

func damage(amount: int):
	life -= amount
	if life <= 0:
		#troubleshooting some stuff
		print("Player died")
		die()
		
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
	get_tree().change_scene_to_file("res://DeathScreen/DeathScreend.tscn")
