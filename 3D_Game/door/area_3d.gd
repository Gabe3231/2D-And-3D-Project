
# this code is for door detection area lowkey should have named it better 
# don't mess with name unless u want to chnage name everywhere its refrenced.
extends Area3D

@export var nextScene: String = "res://main_menu.tscn"

var triggered := false

func _ready():
	body_entered.connect(_on_body_entered)
# basic trigger to detect when player in area to then go to next scene that bein survive scene
func _on_body_entered(body):
	if triggered:
		return
	if body.name != "Player":
		return
	triggered = true
	get_tree().change_scene_to_file(nextScene)
