extends Node2D


func _on_retry_button_down() -> void:
	get_tree().change_scene_to_file("res://level.tscn")


func _on_controls_button_down() -> void:
	get_tree().change_scene_to_file("res://controls/control_menu.tscn")
