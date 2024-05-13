extends Node
class_name State

signal transition(state : State, new_state_name : StringName)

func enter() -> void:
	pass

func exit() -> void:
	pass

func update(_delta) -> void:
	pass

func physics_update(_delta) -> void:
	pass
