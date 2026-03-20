extends Node

#setting up variables for later implmentation
var game_running : bool
var game_over : bool
var scroll
var score
const scroll_speed : int = 4
var screen_size : Vector2i
var ground_height : int
var pipes : Array
const pipe_delay : int = 100
const pipe_range : int = 200

func _ready():
	new_game()

func new_game():
	game_running = false
	game_over = false
	score = 0
	scroll = 0
	$ship.reset()

#lab 2 stuff ignore
# func _input(event):
# 	if game_over == false:
# 		# usinf mouse for now may transition to ekybinds
# 		if event is InputEventMouseButton:
# 			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
# 				if game_running == false:
# 					start_game()
# 				else:
# 					if $ship.flying:
# 						$ship.flap()

# func start_game():
# 	game_running = true
# 	$ship.flying = true
# 	$ship.flap()
	
