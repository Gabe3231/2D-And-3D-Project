extends AnimatedSprite2D

signal finished

# playing death animation
func _ready() -> void:
	frame = 0
	play("default")

# makes sure it dequeues
func _on_finished() -> void:
	finished.emit()
	queue_free()
