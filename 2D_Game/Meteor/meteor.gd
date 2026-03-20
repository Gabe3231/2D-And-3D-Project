extends Area2D

# stuff we change on the go to make game fair
@export var minspeed: float = 100.0
@export var maxspeed: float = 200.0
@export var minrotationspeed: float = -30.0
@export var maxrotationspeed: float = 30.0
@export var life: int = 20
@export var touch_damage: int = 1

var oMeteorEffect := preload("res://meteor_effect.tscn")

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
		effect.global_position = global_position
		queue_free()

func _on_body_entered(body: Node):
	if body is player:
		body.damage(touch_damage)
		queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
