extends Node

var audio_player : AudioStreamPlayer
@export var intro : AudioStreamWAV
@export var looping : AudioStreamWAV

# Called when the node enters the scene tree for the first time.
func _ready():
	audio_player = get_tree().get_first_node_in_group("song_player") as AudioStreamPlayer
	if !audio_player:
		return
	audio_player.finished.connect(on_finished)
	audio_player.play()
	print("Playing: "+audio_player.stream.resource_path)

func on_finished():
	audio_player.stream = looping
	audio_player.play()
	print("Playing: "+audio_player.stream.resource_path)
	print()
