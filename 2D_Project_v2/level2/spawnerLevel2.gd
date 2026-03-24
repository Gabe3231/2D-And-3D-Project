extends Node2D

@onready var spawnTimer := $SpawnTimer
@onready var level_timer := get_tree().current_scene.get_node("LevelTimer")

# the ray things (calling them animals for the story)
# hard coding them in
var preloadedEnemy = [preload("res://OtherShips/other_ships.tscn"),]

var NextSpawn := 0.5

# timer 
func _ready():
	randomize()
	spawnTimer.timeout.connect(_on_spawn_timer_timeout)
	spawnTimer.start(NextSpawn)

# random spawn on x axis
func _on_spawn_timer_timeout() -> void:
	var enemyPreload = preloadedEnemy[randi() % preloadedEnemy.size()]
	var enemy = enemyPreload.instantiate()
	#spawn position on x axis
	var xPos = randf_range(-400.0, 500.0)
	enemy.global_position = Vector2(xPos, 0.0)
	spawnTimer.start(NextSpawn)
	get_tree().current_scene.add_child(enemy)

	spawnTimer.start(NextSpawn)
	
func _process(_delta):
	# 120 - 110 = 10
	# this is so spwaning stops at the last 10 seconds to player knows next level is incoming
	if level_timer.time_left <= 5:
		spawnTimer.stop()
