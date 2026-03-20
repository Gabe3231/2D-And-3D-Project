extends Node2D

@onready var spawnTimer := $SpawnTimer

var preloadedEnemy = [
	preload("res://OtherShips/other_ships.tscn"),
]

var NextSpawn := 0.5

func _ready():
	randomize()
	spawnTimer.timeout.connect(_on_spawn_timer_timeout)
	spawnTimer.start(NextSpawn)

func _on_spawn_timer_timeout() -> void:
	var enemyPreload = preloadedEnemy[randi() % preloadedEnemy.size()]
	var enemy = enemyPreload.instantiate()

	var xPos = randf_range(-350.0, 350.0)
	enemy.global_position = Vector2(xPos, 0.0)

	get_tree().current_scene.add_child(enemy)

	spawnTimer.start(NextSpawn)
