extends Node2D

@onready var label: RichTextLabel = $RichTextLabel

# basic connection to next scene when clicked
func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://menu/main_menu.tscn")

# formatting text better
func _ready():
	label.bbcode_enabled = true
	label.text = "[center][b][font_size=36]WASD (to move)

AND

ARROW KEYS (to move)

SHIFT TO SPRINT

SPACE TO JUMP

F to use flashlight[/font_size][/b][/center]"
