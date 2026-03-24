extends Node2D

@onready var spawnTimer := $SpawnTimer

var preloadedEnemy = [preload("res://UFO/ufo.tscn")]

var NextSpawn := 1.0
var maxUFOs := 5

func _ready():
	randomize()
	spawnTimer.timeout.connect(_on_spawn_timer_timeout)
	spawnTimer.start(NextSpawn)

func _on_spawn_timer_timeout() -> void:
	var currentUFOs = get_tree().get_nodes_in_group("ufo")
	
	if currentUFOs.size() < maxUFOs:
		var enemyPreload = preloadedEnemy[randi() % preloadedEnemy.size()]
		var enemy = enemyPreload.instantiate()
		var xPos = randf_range(-380.0, 380.0)
		enemy.global_position = Vector2(xPos, 0.0)
		get_tree().current_scene.add_child(enemy)

	spawnTimer.start(NextSpawn)
