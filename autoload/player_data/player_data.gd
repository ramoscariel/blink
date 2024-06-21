extends Node

@export var max_health : int
var level : int = 1
var xp : int = 0
var xp_to_next_level : int = 15

signal leveled_up

func add_xp(amount : int):
	xp += amount
	print("xp: "+str(xp))
	if xp >= xp_to_next_level:
		level_up()
	
func level_up():
	level+=1
	print("level: "+str(level))
	var leftovers = xp-xp_to_next_level
	xp = leftovers
	xp_to_next_level += xp_to_next_level*0.2
	print("xp_to_next_level: "+str(xp_to_next_level))
	leveled_up.emit()
