extends Node2D
class_name FlockManager

const AGENT_DENSITY : float = 0.08

@export var agents_scenes : Array[PackedScene]
@export_range(0,500) var starting_size : int = 100
@export_range(1,100) var drive_factor : float = 10
@export_range(1,100) var max_speed : float = 50
@export_range(1,10) var neighbor_radius : float = 1.5
@export_range(0,1) var avoidance_radius_multiplier : float = 0.5
@export var spawn_circle_radius : float 

var agents : Array[FlockAgent]
var behavior : FlockBehavior
var square_max_speed : float
var square_neighbor_radius : float
var square_avoidance_radius : float

func _ready():
	initialize_squares()
	instantiate_flock()
	print(agents.size())

func instantiate_flock():
	if agents_scenes.is_empty():
		return
	for i in starting_size:
		create_agent(i)

func _process(delta):
	pass

func create_agent(iterator : int):
	# Create and set position inside a circle centered on current global_position
	var agent_instace : CharacterBody2D = agents_scenes.pick_random().instantiate()
	agent_instace.global_position = global_position +(
	Vector2.ONE * randf_range(0, spawn_circle_radius)).rotated(randf_range(0, TAU)) * AGENT_DENSITY * starting_size
	agent_instace.name = "Agent "+str(iterator)
	get_parent().add_child.call_deferred(agent_instace)
	
	# Add agent_component to agents
	agents.append((agent_instace as Rat).flock_agent)

func agents_iteration():
	for agent in agents:
		pass

func initialize_squares():
	square_max_speed = max_speed**2
	square_neighbor_radius = neighbor_radius**2
	square_avoidance_radius = square_neighbor_radius * avoidance_radius_multiplier * avoidance_radius_multiplier
