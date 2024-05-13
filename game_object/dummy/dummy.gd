extends CharacterBody2D
class_name Dummy

var health_comp : HealthComp
var player : Node2D
var speed : float = 150
var dir : Vector2
var ray_cast : RayCast2D

func _ready():
	player = get_tree().get_first_node_in_group("player") as Node2D
	health_comp = $HealthComp as HealthComp
	ray_cast = $RayCast2D
	print(health_comp.current_health)

func _physics_process(delta):
	var player_pos = player.global_position
	var direction_to_playerz = (player_pos-global_position).normalized()
	#ray_cast.target_position = 50*direction_to_player
	if !ray_cast.is_colliding() && global_position.distance_squared_to(player_pos) > 100: 
		#dir = direction_to_player
		pass
	else:
		dir = Vector2.ZERO
	velocity = dir*speed
	print(velocity)
	move_and_slide()

func _process(delta):
	pass
