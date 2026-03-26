extends Control

#This screen can be copied and pasted for other scenes
# Be sure to just chnage scene paths

# Restarts that scene
func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://MainScenes/gameplay.tscn")

# Goes back to start screen
func _on_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://Controls/controls.tscn")
