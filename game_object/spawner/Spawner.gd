extends Node2D
class_name Spawner

@export var entity : PackedScene
@export var spawn_radius : float
@export var time_to_spawn : float

var spawn_timer : Timer

var player : Player

func _ready():
	spawn_timer = $SpawnTimer as Timer
	spawn_timer.wait_time = time_to_spawn
	spawn_timer.timeout.connect(on_timeout)
	player = get_tree().get_first_node_in_group("player") as Player

#Spawns something offscreen to the player
func spawn_entity():
	if !player || !entity:
		return
	var player_location := player.global_position
	var random_pos = player_location+Vector2.RIGHT.rotated(randf_range(0,TAU))*spawn_radius
	var an_entity = entity.instantiate() as Node2D
	an_entity.global_position = random_pos
	get_parent().add_child(an_entity)

func on_timeout():
	spawn_entity()
