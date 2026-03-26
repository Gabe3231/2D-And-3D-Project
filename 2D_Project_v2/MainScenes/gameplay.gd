extends Node2D

@onready var level_timer := $LevelTimer
@onready var transition := $Fade

# just in case cuz we've had issues 
var triggered := false

# once level complete it chnages to next scene
func _process(_delta: float):
	# the check to ensure level chnage
	if not triggered and level_timer.time_left <= 2.0:
		triggered = true
		transition.start_transition("res://Story/story_scene_2.tscn")
