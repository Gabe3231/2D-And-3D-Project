extends Timer

func _ready() -> void:
	var scene_name = get_tree().current_scene.name

# set time for each level based on root node name
	if scene_name == "Gameplay":
		start(60.0)
	elif scene_name == "LevelTwo":
		start(30.0)
	elif scene_name == "levelThree":
		start(60.0)
