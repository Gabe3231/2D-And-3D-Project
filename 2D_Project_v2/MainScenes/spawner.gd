extends Node2D

@onready var spawnTimer := $SpawnTimer
@onready var level_timer := get_tree().current_scene.get_node("LevelTimer")

# required asset
var preloadedEnemy = [preload("res://Meteor/meteor.tscn")]
# spawn rate
var NextSpawn := .5

# make sure enemy spawn is random
func _ready():
	randomize()
	spawnTimer.start(NextSpawn)

func _on_spawn_timer_timeout():
	var enemyPreload = preloadedEnemy[randi() % preloadedEnemy.size()]
	var enemy = enemyPreload.instantiate()
	# random spawn bewteen these two ranges on x axis
	var xPos = randf_range(-350.0, 350.0)
	enemy.global_position = Vector2(xPos, 0.0)
	get_tree().current_scene.add_child(enemy)
	spawnTimer.start(NextSpawn)
	
func _process(_delta):
	# exmaple: 120 - 110 = 10
	# this is so spwaning stops at the last 10 seconds to player knows next level is incoming
	# chnage as needed to balance game
	if level_timer.time_left <= 5:
		spawnTimer.stop()
