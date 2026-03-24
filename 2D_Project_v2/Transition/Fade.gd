extends CanvasLayer

@onready var color_rect: ColorRect = $ColorRect
@onready var timer: Timer = $Timer

# each level sets this to tell the fade where to go next
var next_scene: String = ""

func _ready() -> void:
	color_rect.modulate.a = 0.0
	timer.timeout.connect(_on_timeout)

func _on_timeout() -> void:
	print("Switching scene")
	get_tree().change_scene_to_file(next_scene)

func start_transition(target_scene: String) -> void:
	print("Transition")
	next_scene = target_scene
	#music volume tweak for end transition
	var music = get_parent().get_node("AudioStreamPlayer2D")
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(color_rect, "modulate:a", 1.0, 2.0)
	tween.tween_property(music, "volume_db", -40.0, 2.0)

	timer.start(2.0)
