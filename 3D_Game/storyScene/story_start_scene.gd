extends Node

#next level
@export var gameScenePath := "res://level.tscn"

# time before switch
@export var storyTime := 5.0
@export var fadeTime := 1.5
@onready var fadeRect: ColorRect = $CanvasLayer/Fade
@onready var timer: Timer = $Timer


func _ready():
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
