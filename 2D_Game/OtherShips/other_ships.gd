extends Area2D

@export var minspeed: float = 100.0
@export var maxspeed: float = 200.0

var speed: float = 0.0

func _ready() -> void:
	speed = randf_range(minspeed, maxspeed)
	body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
	position.y += speed * delta

func _on_body_entered(body: Node) -> void:
	if body.has_method("die"):
		body.die()
		queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
