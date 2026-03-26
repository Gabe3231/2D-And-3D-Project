extends Area2D
 
# speed settings
# all accurate
@export var minspeed: float = 80.0
@export var maxspeed: float = 130.0
@export var life: int = 3
@export var touch_damage: int = 1
@export var driftAmplitude: float = 60.0
@export var driftSpeed: float = 2.0
@export var fireRate: float = 1.0
 
# required assets
var oUFOExplosion := preload("res://Meteor/meteor_explosion.tscn")
var oEnemyLaser := preload("res://UFO/enemy_laser.tscn")
 
var speed: float = 0.0
var time: float = 0.0
var startX: float = 0.0
 
@onready var fireTimer := $FireDelayTimer
 

func _ready():
	# set random speed and to set collision and to set shoot speed
	speed = randf_range(minspeed, maxspeed)
	startX = position.x
	body_entered.connect(_on_body_entered)
	fireTimer.wait_time = fireRate
	fireTimer.start()
 
# setting spawn position on x axis and side to side movement
func _physics_process(delta: float):
	position.y += speed * delta
	time += delta
	position.x = startX + sin(time * driftSpeed) * driftAmplitude
	# Only delete if it goes below screen
	var screen_height = get_viewport_rect().size.y
	#the 50 is a buffer so it queus after the enemy moves farther than 50 pixels
	if position.y > screen_height + 50: 
		queue_free()
 
# sets shooting position in enemy
func shoot():
	var laser = oEnemyLaser.instantiate()
	laser.global_position = $ShootingPosition.global_position
	get_tree().current_scene.add_child(laser)
 
# ufo life and death animation
func damage(amount: int):
	life -= amount
	if life <= 0:
		var effect = oUFOExplosion.instantiate()
		get_tree().current_scene.add_child(effect)
		effect.global_position = $Sprite2D.global_position
		queue_free()
 
# collision physics
func _on_body_entered(body: Node):
	if body.is_in_group("player"):
		body.damage(1)
		queue_free()
 
func _on_fire_delay_timer_timeout() -> void:
	shoot()
	fireTimer.start()
