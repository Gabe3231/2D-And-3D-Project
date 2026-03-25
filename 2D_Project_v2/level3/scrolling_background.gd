extends Node2D

@export var speed: float = 100.0

@onready var sprite1 := $Sprite1
@onready var sprite2 := $Sprite2

var texture_height: float = 0.0

func _ready() -> void:
	texture_height = sprite1.texture.get_height() * sprite1.scale.y
	sprite1.position.y = texture_height / 2
	sprite2.position.y = -texture_height / 2

func _process(delta: float) -> void:
	sprite1.position.y += speed * delta
	sprite2.position.y += speed * delta

	if sprite1.position.y > texture_height * 1.5:
		sprite1.position.y = sprite2.position.y - texture_height

	if sprite2.position.y > texture_height * 1.5:
		sprite2.position.y = sprite1.position.y - texture_height
