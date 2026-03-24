extends AnimatedSprite2D

signal finished

func _ready() -> void:
	frame = 0
	play("default")


func _on_finished() -> void:
	finished.emit()
	queue_free()
