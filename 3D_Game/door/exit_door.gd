extends Node3D

@onready var fade_rect: ColorRect = $CanvasLayer/FadeReact
@export var next_scene_path := "res://death_screen.tscn"

var used := false

func _ready() -> void:
	fade_rect.visible = true
	fade_rect.color = Color.BLACK
	fade_rect.modulate.a = 0.0
	fade_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _on_area_3d_body_entered(body: Node3D) -> void:
	print("BODY ENTERED DOOR AREA: ", body.name)

	if used:
		return

	if body is CharacterBody3D:
		used = true
		fade_out()

func fade_out() -> void:
	print("FADING OUT")

	var tween := create_tween()
	tween.tween_property(fade_rect, "modulate:a", 1.0, 1.5)
	tween.tween_callback(go_to_next_scene)

func go_to_next_scene() -> void:
	get_tree().change_scene_to_file("res://SurvivedScene/survived_scene.tscn")
