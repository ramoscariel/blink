extends Node
class_name LookAtComp

var parent_node : Node2D
@export var rotation_speed : float

func _ready():
	parent_node = get_parent() as Node2D

func rotateToTarget(target_pos : Vector2, delta):
	var dir = target_pos-parent_node.position
	var angle_to_dir = parent_node.get_angle_to(dir)
	parent_node.rotate(sign(angle_to_dir)*min(delta*rotation_speed,abs(angle_to_dir)))
