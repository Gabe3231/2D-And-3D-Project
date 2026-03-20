extends Node2D

@onready var spawnTimer := $SpawnTimer

var preloadedEnemy = [preload("res://Meteor/meteor.tscn")]
var NextSpawn := .5

func _ready():
	randomize()
	spawnTimer.start(NextSpawn)

func _on_spawn_timer_timeout():
	var enemyPreload = preloadedEnemy[randi() % preloadedEnemy.size()]
	var enemy = enemyPreload.instantiate()
	# random spawn bewteen these two ranges on x axis
	var xPos = randf_range(-150.0, 200.0)
	enemy.global_position = Vector2(xPos, 0.0)
	get_tree().current_scene.add_child(enemy)
	spawnTimer.start(NextSpawn)
