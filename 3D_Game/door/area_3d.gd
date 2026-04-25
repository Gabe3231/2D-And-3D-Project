extends Area3D

@export var nextScene: String = "res://main_menu.tscn"

var triggered := false

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if triggered:
		return

	if body.name != "Player":
		return

	triggered = true

	print("Player reached exit") # debug

	get_tree().change_scene_to_file(nextScene)
