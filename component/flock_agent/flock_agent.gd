extends Node
class_name FlockAgent

@export var agent_collider : Area2D
var vel : Vector2

func move(velocity : Vector2):
	vel = velocity
