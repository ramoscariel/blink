extends Node
class_name SpeedComp

@export var current_speed : float
@export var target_speed : float
@export var acceleration_factor : float

func accelerate(delta):
	current_speed = min(current_speed+acceleration_factor*delta,target_speed)
	
func deaccelerate(delta):
	current_speed = max(current_speed-acceleration_factor*delta,0)
