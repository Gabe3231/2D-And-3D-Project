extends Area2D

@export var laserSpeed: float = 200.0
 
func _physics_process(delta: float) -> void:
	position.y += laserSpeed * delta
 
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
 
func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		body.damage(1)
		queue_free()
