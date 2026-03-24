extends Control

func _on_button_pressed() -> void:
	print("Retry pressed")
	get_tree().change_scene_to_file("res://level2/level_two.tscn")

func _on_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://Controls/controls.tscn")
