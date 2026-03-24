extends CharacterBody2D

var plLaser := preload("res://Laser/laser.tscn")
var pDeathEffect := preload("res://Player/PlayerDeath.tscn")

@onready var firingPosition := $FiringPosition
@onready var fireDelayTimer := $FireDelayTimer
@onready var hud := get_tree().current_scene.get_node("HUD")

@export var life: int = 3
@export var speed: float = 200.0
@export var fireDelay: float = 0.2

var is_dead := false

func _process(_delta):
	if Input.is_action_just_pressed("shoot") and fireDelayTimer.is_stopped():
		fireDelayTimer.start(fireDelay)
		for weapon in firingPosition.get_children():
			var laser = plLaser.instantiate()
			laser.global_position = weapon.global_position
			get_tree().current_scene.add_child(laser)

func _physics_process(_delta):
	var dirVec := Vector2.ZERO
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
		die()

func die():
	if is_dead:
		return
	is_dead = true
	hide()
	set_physics_process(false)
	set_process(false)
	var effect = pDeathEffect.instantiate()
	get_tree().current_scene.add_child(effect)
	effect.global_position = $Sprite2D.global_position
	effect.z_index = 100
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://DeathScreen/death_screen_3.tscn")
