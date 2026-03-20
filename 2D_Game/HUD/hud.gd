extends Control

@onready var lifeContainer := $lifeContainer
@onready var progress_bar := $ProgressBar
@onready var level_timer := get_tree().current_scene.get_node("LevelTimer")
@onready var player := get_tree().current_scene.get_node("Player")

var pLifeIcon := preload("res://HUD/lifeIcon.tscn")

func _ready():
	setLives(player.life)
	progress_bar.max_value = level_timer.wait_time
	progress_bar.value = level_timer.wait_time

func _process(_delta):
	progress_bar.value = level_timer.time_left

func clearLives():
	for child in lifeContainer.get_children():
		child.queue_free()

func setLives(lives: int):
	clearLives()
	for i in range(lives):
		lifeContainer.add_child(pLifeIcon.instantiate())
