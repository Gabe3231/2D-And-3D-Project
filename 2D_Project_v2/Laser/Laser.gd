extends Area2D

# set to 350 
@export var speed : float = 350

# laser speed going up y axis from player
func _physics_process(delta):
	position.y -= speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	#remove nodes
	queue_free()

# does 1 damage when entering area
func _on_area_entered(area):
	if area.is_in_group("damagable"):
		area.damage(1)
		queue_free()
