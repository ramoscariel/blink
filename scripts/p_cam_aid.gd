extends Node2D

var player : Node2D

func _ready():
	player = get_tree().get_first_node_in_group("player") as Node2D
	if !player: 
		return
	position = player.position
func _process(_delta):
	if !player:
		return
	position = player.position

