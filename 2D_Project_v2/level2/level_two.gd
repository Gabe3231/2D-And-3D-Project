extends Node2D

@onready var level_timer := $LevelTimer
@onready var fade := $Fade

var triggered := false

func _process(_delta: float) -> void:
	if not triggered and level_timer.time_left <= 2.0:
		triggered = true
		fade.start_transition("res://Story/story_scene_3.tscn")
