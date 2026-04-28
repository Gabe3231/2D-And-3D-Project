extends Node2D

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://storyScene/story_start_scene.tscn")


func _on_controls_pressed() -> void:
	get_tree().change_scene_to_file("res://controls/control_menu.tscn")
