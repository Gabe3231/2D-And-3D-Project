extends Node

#setting up variables for later implmentation
var game_running : bool
var game_over : bool
var scroll
var score
@export var scroll_speed: int = 4
var screen_size : Vector2i
var ground_height : int
var pipes : Array
const pipe_delay : int = 100
const pipe_range : int = 200

func _ready():
	screen_size = get_window().size
	new_game()

func new_game():
	game_running = false
	game_over = false
	score = 0
	scroll = 0
	$ship.reset()

func start_game():
	game_running = true
	$ship.flying = true
	$ship.flap()
	
func _process(delta):
	# input using Maped input
	if not game_over and Input.is_action_just_pressed("flap"):
		if not game_running:
			start_game()
		elif $ship.flying:
			$ship.flap()
	if game_running:
		scroll -= scroll_speed
		if scroll <= -screen_size.x:
			scroll = 0
		$ground.position.x = scroll
		
# need to implment death 
