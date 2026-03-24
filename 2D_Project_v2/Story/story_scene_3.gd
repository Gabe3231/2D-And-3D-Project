extends Control

func _on_button_pressed() -> void:
	var err := get_tree().change_scene_to_file("res://level3/level_three.tscn")
