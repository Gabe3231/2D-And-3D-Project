extends Node2D

@export var game_scene: PackedScene
@onready var label = $RichTextLabel

func _ready() -> void:
	# used to display text 
	label.bbcode_enabled = true
	#various text and text settings like color, font and size
	label.text = "[color=red][center][b][font_size=80]SPACE DELIVERY[/font_size][/b][/center][/color]\n\n"
	label.text += "[color=red][font_size=40][b]Controls / Rules:[/b][/font_size][/color]\n"
	label.text += "[color=red][font_size=40]Up Arrow = Move Up [/font_size][/color]\n"
	label.text += "[color=red][font_size=40]Right Arrow = Move Right [/font_size][/color]\n"
	label.text += "[color=red][font_size=40]Left Arrow = Move Left [/font_size][/color]\n"
	label.text += "[color=red][font_size=40]Down Arrow = Move Down [/font_size][/color]\n"
	label.text += "[color=red][font_size=40]Space or Mouse = Shoot [/font_size][/color]\n"
	label.text += "[color=red][font_size=60]Avoid All Obstacles [/font_size][/color]\n"
	label.text += "[font_size=30][color=red]Press Play To Begin[/color][/font_size]"

#next scene
func _on_button_pressed() -> void:
	var err := get_tree().change_scene_to_file("res://Story/story_scene1.tscn")
