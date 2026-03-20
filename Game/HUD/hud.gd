extends Control

@onready var lifeContainer := $lifeContainer
var pLifeIcon := preload	("res://HUD/lifeIcon.tscn")

func _ready():
	clearLives()
	setLives(1)
	
func clearLives():
	for child in lifeContainer.get_children():
		lifeContainer.remove_child(child)
		child.queue_free()

func setLives(lives: int):
	clearLives()
	for i in range(lives):
		lifeContainer.add_child(pLifeIcon.instantiate())
	
