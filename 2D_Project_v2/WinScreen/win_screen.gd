extends Control

# send user back to start screen
func _on_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://Controls/controls.tscn")
