extends Timer

func _ready():
	timeout.connect(_on_timeout)
	start(20.0)

func _on_timeout():
	print("Timer done")
	get_tree().change_scene_to_file("res://level2/level_two.tscn")
