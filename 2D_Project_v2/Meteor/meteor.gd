extends Area2D

# stuff we change on the go to make game fair
#180
@export var minspeed: float = 180.0
#230
@export var maxspeed: float = 230.0
#-5
@export var minrotationspeed: float = -10.0
#10
@export var maxrotationspeed: float = 10.0
#3
@export var life: int = 3
@export var touch_damage: int = 1

var oMeteorEffect := preload("res://Meteor/meteor_explosion.tscn")

var speed: float = 0.0
var rotationRate: float = 0.0

func _ready() -> void:
	speed = randf_range(minspeed, maxspeed)
	rotationRate = randf_range(minrotationspeed, maxrotationspeed)

	body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
	rotation_degrees += rotationRate * delta
	position.y += speed * delta

func damage(amount: int) -> void:
	life -= amount
	if life <= 0:
		var effect = oMeteorEffect.instantiate()
		get_tree().current_scene.add_child(effect)
		effect.global_position = $Sprite2D.global_position
		queue_free()

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		body.damage(touch_damage)
		queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
