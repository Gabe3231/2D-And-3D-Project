extends Area2D

@export var laserSpeed: float = 200.0
 
func _physics_process(delta: float) -> void:
	position.y += laserSpeed * delta
 
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
 
func _on_body_entered(body: Node) -> void:
	if body is player:
		body.damage(1)
		queue_free()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	pass # Replace with function body.
