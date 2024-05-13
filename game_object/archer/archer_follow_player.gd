extends ArcherState
class_name ArcherFollowPlayer

@export var prox_thres : float

func enter() -> void:
	super.enter()

func exit() -> void:
	super.exit()

func update(_delta) -> void:
	super.update(_delta)

func physics_update(_delta) -> void:
	if !knockback_comp.is_being_knocked:
		follow_player()
	character_body.move_and_slide()

# Sets velocity to follow the player
func follow_player():
	if !player:
		return
	var dir : Vector2
	if (character_body.global_position.distance_squared_to(player.global_position) > 
	prox_thres*prox_thres):
		dir = dir_to_player.normalized()
	else:
		dir = Vector2.ZERO
	character_body.velocity = dir*move_speed
