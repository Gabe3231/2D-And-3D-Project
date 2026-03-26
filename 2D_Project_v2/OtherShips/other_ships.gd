extends Area2D

# set to 150 in game
@export var minspeed: float = 150.0
# set to 250 in game
@export var maxspeed: float = 250.0

var speed: float = 0.0

# randomizes speed and connects physics of collisions
func _ready():
	speed = randf_range(minspeed, maxspeed)
	body_entered.connect(_on_body_entered)

# objects move down the Y axis
func _physics_process(delta: float):
	position.y += speed * delta

# basic 
func _on_body_entered(body: Node):
	if body.has_method("die"):
		body.die()
		queue_free()

# computer started lagging cuz too many rays
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
