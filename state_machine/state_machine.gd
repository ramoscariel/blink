extends Node
class_name StateMachine

@export var current_state : State
var states: Dictionary = {}

func _ready():
	for child in get_children():
		if child is State:
			child.transition.connect(on_state_transition)
			states[child.name.to_lower()] = child
	if current_state:
		current_state.enter()
			
func _process(delta):
	if current_state:
		current_state.update(delta)
	
func _physics_process(delta):
	if current_state:
		current_state.physics_update(delta)

func on_state_transition(state : State, new_state_name : StringName):
	if !current_state:
		return
	if state != current_state:
		return
	if !states.has(new_state_name.to_lower()):
		return
	current_state.exit()
	current_state = states[new_state_name.to_lower()]
	current_state.enter()
