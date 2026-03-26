extends Node2D

@onready var level_timer := $LevelTimer
@onready var transition := $Fade
@onready var player := $Player
@onready var spawner := $Spawner

var triggered := false

# once level complete it chnages to next scene
func _process(_delta: float) -> void:
	# the check to ensure level chnage
	if not triggered and level_timer.time_left <= 2.0:
		triggered = true
		# had some issues with level 3 transition so I set more checks
		# likly a currpoted image issue
		player.level_complete = true
		player.set_physics_process(false)
		player.set_process(false)
		if spawner and spawner.has_node("SpawnTimer"):
			spawner.get_node("SpawnTimer").stop()

		transition.start_transition("res://WinScreen/win_screen.tscn")
