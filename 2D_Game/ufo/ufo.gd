extends Area2D
 
# speed settings
@export var minspeed: float = 80.0
@export var maxspeed: float = 130.0
@export var life: int = 3
@export var touch_damage: int = 1
@export var driftAmplitude: float = 60.0
@export var driftSpeed: float = 2.0
@export var fireRate: float = 1.0
 
var oUFOExplosion := preload("res://Meteor/meteor_explosion.tscn")
var oEnemyLaser := preload("res://UFO/enemy_laser.tscn")
 
var speed: float = 0.0
var time: float = 0.0
var startX: float = 0.0
 
@onready var fireTimer := $FireDelayTimer
 
func _ready() -> void:
	speed = randf_range(minspeed, maxspeed)
	startX = position.x
	body_entered.connect(_on_body_entered)
	fireTimer.wait_time = fireRate
	fireTimer.start()
 
func _physics_process(delta: float) -> void:
	position.y += speed * delta
	time += delta
	position.x = startX + sin(time * driftSpeed) * driftAmplitude
 
func shoot() -> void:
	var laser = oEnemyLaser.instantiate()
	laser.global_position = $ShootingPosition.global_position
	get_tree().current_scene.add_child(laser)
 
func damage(amount: int) -> void:
	life -= amount
	if life <= 0:
		var effect = oUFOExplosion.instantiate()
		get_tree().current_scene.add_child(effect)
		effect.global_position = $Sprite2D.global_position
		queue_free()
 
func _on_body_entered(body: Node) -> void:
	if body is player:
		body.damage(touch_damage)
		queue_free()
 
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
 
func _on_fire_delay_timer_timeout() -> void:
	shoot()
	fireTimer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_fire_delay_timeout() -> void:
	pass # Replace with function body.
