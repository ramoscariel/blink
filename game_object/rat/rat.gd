extends CharacterBody2D
class_name Rat

var flock_agent : FlockAgent

func _enter_tree():
	flock_agent = $FlockAgent
