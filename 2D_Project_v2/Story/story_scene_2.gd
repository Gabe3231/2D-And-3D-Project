extends Control
# to go to next scene
func _on_button_pressed() -> void:
	var err := get_tree().change_scene_to_file("res://level2/level_two.tscn")
