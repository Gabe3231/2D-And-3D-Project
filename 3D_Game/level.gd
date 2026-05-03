extends Node3D

@onready var player: AudioStreamPlayer3D = $AudioStreamPlayer3D

func stop_music():
	player.stop()
