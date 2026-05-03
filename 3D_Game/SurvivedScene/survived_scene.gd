extends Node2D

@onready var label: RichTextLabel = $RichTextLabel


# had mouse issue where i could not click out of game
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	# text formatting
	label.bbcode_enabled = true
	label.text = "[center]\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n[outline_size=2][outline_color=black][b][font_size=36]This is where the footage stops.

[color=red]No other footage was recovered[/color] beyond this point.

It is likely that there are [color=red]other tapes[/color] scattered throughout other sections.

Whatever you encountered in there...

[color=red]it is still inside.[/color][/font_size][/b][/outline_color][/outline_size][/center]"

func _on_play_again_pressed() -> void:
	get_tree().change_scene_to_file("res://storyScene/story_start_scene.tscn")


func _on_exit_pressed() -> void:
	get_tree().quit()
