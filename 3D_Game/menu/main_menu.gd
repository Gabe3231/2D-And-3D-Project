extends Node2D

@onready var label: RichTextLabel = $RichTextLabel

# go to scene
func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://storyScene/story_start_scene.tscn")


func _on_controls_pressed() -> void:
	get_tree().change_scene_to_file("res://controls/control_menu.tscn")
	
func _ready():
	label.position.y = 200
	label.bbcode_enabled = true
	label.text = "[center][outline_size=2][outline_color=black][b][font_size=80]\n\nFalse Exit[/font_size][/b][/outline_color][/outline_size][/center]"
