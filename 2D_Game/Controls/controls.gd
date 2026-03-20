extends Node2D

@export var game_scene: PackedScene
@onready var label = $RichTextLabel

func _ready() -> void:
	# used to display text 
	label.bbcode_enabled = true
	#various text and text settings like color, font and size
	label.text = "[color=red][center][b][font_size=80]SPACE DELIVERY[/font_size][/b][/center][/color]\n\n"
	label.text += "[color=red][font_size=40][b]Controls:[/b][/font_size][/color]\n"
	label.text += "[color=red][font_size=40]Up Arrow = Move Up [/font_size][/color]\n"
	label.text += "[color=red][font_size=40]Right Arrow = Move Right [/font_size][/color]\n"
	label.text += "[color=red][font_size=40]Left Arrow = Move Left [/font_size][/color]\n"
	label.text += "[color=red][font_size=40]Down Arrow = Move Down [/font_size][/color]\n"
	label.text += "[color=red][font_size=40]Space or Mouse = Shoot [/font_size][/color]\n"
	label.text += "[font_size=30]Enter - Start Game[/font_size]\n\n"
	label.text += "[font_size=30][color=red]Press Space or Enter to Begin[/color][/font_size]"


func _on_texture_button_pressed() -> void:
	var err := get_tree().change_scene_to_file("res://Story/story_scene1.tscn")
	print("change_scene err =", err)
