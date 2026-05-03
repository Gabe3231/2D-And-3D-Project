extends Node2D

@onready var label: RichTextLabel = $RichTextLabel

func _ready():
	label.bbcode_enabled = true
	label.text = "[center][outline_size=2][outline_color=black][b]\n\n\n[font_size=36]The footage has been [color=red]CORRUPTED[/color].

Whatever was in that maze with you...

[color=red]it found you first.[/color][/font_size][/b][/outline_color][/outline_size][/center]"

# basic connection to next scene when clicked
func _on_retry_button_down() -> void:
	get_tree().change_scene_to_file("res://level.tscn")

func _on_controls_button_down() -> void:
	get_tree().change_scene_to_file("res://controls/control_menu.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()
