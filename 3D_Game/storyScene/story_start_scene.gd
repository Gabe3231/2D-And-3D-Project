extends Node

@export var game_scene_path := "res://level.tscn"
@export var story_time := 5.0
@export var fade_time := 1.5

@onready var fade_rect: ColorRect = $CanvasLayer/Fade
@onready var timer: Timer = $Timer

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	fade_rect.visible = true
	fade_rect.color = Color.BLACK
	fade_rect.modulate.a = 0.0
	fade_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE

	timer.wait_time = story_time
	timer.one_shot = true
	timer.timeout.connect(_on_timer_timeout)
	timer.start()

func _on_timer_timeout() -> void:
	fade_to_game()

func fade_to_game() -> void:
	var tween := create_tween()
	tween.tween_property(fade_rect, "modulate:a", 1.0, fade_time)
	tween.finished.connect(change_to_game)

func change_to_game() -> void:
	get_tree().change_scene_to_file(game_scene_path)
