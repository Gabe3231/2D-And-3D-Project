extends Node2D

@export var game_scene: PackedScene
@onready var label = $RichTextLabel

func _ready() -> void:
	# used to display text 
	label.bbcode_enabled = true
	#various text and text settings like color, font and size
	label.text = "[color=red][center][b][font_size=40]SPACE DELIVERY[/font_size][/b][/center][/color]\n\n"
	label.text += "[color=red][b]Controls:[/b][/color]\n"
	label.text += "[color=red]Up Arrow = Move Up [/color]\n"
	label.text += "[color=red]Right Arrow = Move Right [/color]\n"
	label.text += "[color=red]Left Arrow = Move Left [/color]\n"
	label.text += "[color=red]Down Arrow = Move Down [/color]\n"
	label.text += "[color=red]Space or Mouse = Shoot [/color]\n"
	label.text += "Enter - Start Game\n\n"
	label.text += "[color=red]Press Space or Enter to Begin[/color]"


func _on_texture_button_pressed() -> void:
	var err := get_tree().change_scene_to_file("res://Story/story_scene1.tscn")
	print("change_scene err =", err)
