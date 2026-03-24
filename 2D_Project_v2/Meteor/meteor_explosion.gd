extends AnimatedSprite2D      

func _ready() -> void:
	frame = 0
	play("default")

func _on_animation_finished() -> void:
	queue_free()
