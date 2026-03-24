extends Control

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://level3/level_three.tscn")

func _on_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://Controls/controls.tscn")
