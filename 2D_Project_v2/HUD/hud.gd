extends Control

var lifeContainer
var progress_bar
var level_timer
var player

# loading in the lifeIcon
# this was scrapped but left it in for maybe later implmentation
# still need it for managing life as other stuff relies on it
var pLifeIcon := preload("res://HUD/lifeIcon.tscn")

func _ready():
	#where icons are placed
	lifeContainer = get_node_or_null("lifeContainer")
	progress_bar = get_node_or_null("ProgressBar")
	level_timer = get_tree().current_scene.get_node_or_null("LevelTimer")
	#player = get_tree().current_scene.get_node_or_null("Player")

	# maunally setting value to resize bar
	if progress_bar:
		progress_bar.min_value = 0
		progress_bar.max_value = 100
	if player:
		setLives(player.life)

# checks level timer and does math for progress bar percentage
func _process(_delta: float) -> void:
	if progress_bar and level_timer:
		progress_bar.value = (1.0 - level_timer.time_left / level_timer.wait_time) * 100

# removes life icon
# not required but kept for maybe later implmenttion
func clearLives() -> void:
	if not lifeContainer:
		return
	for child in lifeContainer.get_children():
		child.queue_free()

# not required but kept for maybe later implmenttion
func setLives(lives: int) -> void:
	if not lifeContainer:
		return
	clearLives()
	for i in range(lives):
		lifeContainer.add_child(pLifeIcon.instantiate())
