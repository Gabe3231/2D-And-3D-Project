extends Node3D

@onready var fade_rect: ColorRect = $CanvasLayer/FadeReact
#next scene need to go to
@export var next_scene_path := "res://death_screen.tscn"

var used := false

# fade logicand design
func _ready():
	fade_rect.visible = true
	fade_rect.color = Color.BLACK
	fade_rect.modulate.a = 0.0
	fade_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE

# check if player enetered
func _on_area_3d_body_entered(body: Node3D):
	if used:
		return
	if body is CharacterBody3D:
		used = true
		fade_out()

# fade out logic to next scene
func fade_out() -> void:
	var tween := create_tween()
	tween.tween_property(fade_rect, "modulate:a", 1.0, 1.5)
	tween.tween_callback(go_to_next_scene)

func go_to_next_scene() -> void:
	get_tree().change_scene_to_file("res://SurvivedScene/survived_scene.tscn")
