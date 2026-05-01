extends Node2D

@onready var label: RichTextLabel = $Manager/RichTextLabel


# had mouse issue where i could not click out of game
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	# text formatting
	label.bbcode_enabled = true
	label.text = "[center]\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n[b][font_size=36]This is where the footage stops. No other footage was recovered beyond this point. 
	However, it is likely that there are other tapes scattered throughout other sections. [/font_size][/b][/center]"

func _on_play_again_pressed() -> void:
	get_tree().change_scene_to_file("res://storyScene/story_start_scene.tscn")


func _on_exit_pressed() -> void:
	get_tree().quit()
