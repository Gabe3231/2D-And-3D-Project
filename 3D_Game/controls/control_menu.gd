extends Node2D

# basic connection to next scene when clicked
func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://menu/main_menu.tscn")
