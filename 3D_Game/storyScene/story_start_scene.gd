extends Node

#next level
@export var gameScenePath := "res://level.tscn"

# time before switch
@export var storyTime := 20.0
@export var fadeTime := 1.5
@onready var fadeRect: ColorRect = $CanvasLayer/Fade
@onready var timer: Timer = $Timer
@onready var label: RichTextLabel = $CanvasLayer/RichTextLabel

# formatting story text
func _ready():
	label.bbcode_enabled = true
	label.text = "[center]\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n[outline_size=2][outline_color=black][b][font_size=36]Footage was recovered from a camera that had been lost in the subliminal space. It is unknown where this survivor is or their status. It seems the surviors goal was to [color=red]FIND THE EXIT[/color].

This footage serves as training for any personnel entering the maze and its subsequent sections.

This footage serves as a warning to anyone who enters: [color=red]CREATURES LURK WITHIN THE MAZE[/color].

Use this footage to navigate the maze, but [color=red]BE WARY[/color] at all times.[/font_size][/b][/outline_color][/outline_size][/center]"

	# make mouse visable so can click
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	# fade setting
	fadeRect.visible = true
	fadeRect.color = Color.BLACK
	fadeRect.modulate.a = 0.0
	fadeRect.mouse_filter = Control.MOUSE_FILTER_IGNORE

	# timer starts when scene loads
	# waits story time then switches
	timer.wait_time = storyTime
	timer.one_shot = true
	timer.timeout.connect(_on_timer_timeout)
	timer.start()

func _on_timer_timeout():
	fade_to_game()

# fades screen then next scenes
func fade_to_game():
	var tween := create_tween()
	tween.tween_property(fadeRect, "modulate:a", 1.0, fadeTime)
	tween.finished.connect(change_to_game)

#next scene
func change_to_game():
	get_tree().change_scene_to_file(gameScenePath)
	
