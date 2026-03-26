extends CanvasLayer

# refrences nodes
@onready var color_rect: ColorRect = $ColorRect
@onready var timer: Timer = $Timer

# each level sets this to tell the fade where to go next
var next_scene: String = ""

# had issues here kinda hard coded it to make sure the color rect does a transition
# issues resolved was a corrupted image file
func _ready():
	color_rect.modulate.a = 0.0
	timer.timeout.connect(_on_timeout)

# moves to next scene
func _on_timeout():
	get_tree().change_scene_to_file(next_scene)

func start_transition(target_scene: String):
	next_scene = target_scene
	#music volume tweak for end transition
	var music = get_parent().get_node("AudioStreamPlayer2D")
	var tween = create_tween()
	tween.set_parallel(true)
	# setting the color reacts color transition (Hard coded)
	# was also done in inspector but had issues
	tween.tween_property(color_rect, "modulate:a", 1.0, 2.0)
	# makes volume do down to -40 during transition (basically silent)
	tween.tween_property(music, "volume_db", -40.0, 2.0)
	#signal chnage
	timer.start(2.0)
