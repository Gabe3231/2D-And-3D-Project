extends Node2D

@onready var level_timer := $LevelTimer
@onready var transition := $Fade
@onready var player := $Player
@onready var spawner := $Spawner

var triggered := false

func _process(_delta: float) -> void:
	if not triggered and level_timer.time_left <= 2.0:
		triggered = true

		player.level_complete = true
		player.set_physics_process(false)
		player.set_process(false)

		if spawner and spawner.has_node("SpawnTimer"):
			spawner.get_node("SpawnTimer").stop()

		transition.start_transition("res://WinScreen/win_screen.tscn")
