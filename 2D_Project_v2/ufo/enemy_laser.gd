extends Area2D

# So we can chnage on the fly (at 200)
@export var laserSpeed: float = 200.0
 
# basic phsycis for y axis as lasers move down for enemy
func _physics_process(delta: float) -> void:
	position.y += laserSpeed * delta
 
# Make sure it frees the queue once off screem
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
 
# how damage is felt
func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		body.damage(1)
		queue_free()
