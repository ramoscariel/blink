extends CharacterBody2D
class_name Knight

@export var speed_reset : float
var stop_timer : Timer
var sprite : Sprite2D
var knockback_comp : KnockbackComp
var health_comp : HealthComp
var hitbox_comp : HitboxComp
var speed_comp : SpeedComp
var player : Player
var dir : Vector2
var stopped : bool = false

func _ready():
	stop_timer = $StopTimer as Timer
	stop_timer.timeout.connect(on_stop_timer_timeout)
	hitbox_comp = get_node("HitboxComp") as HitboxComp
	hitbox_comp.has_hit.connect(on_has_hit)
	sprite = get_node("Sprite2D") as Sprite2D
	knockback_comp = get_node("KnockbackComp") as KnockbackComp
	health_comp = get_node("HealthComp") as HealthComp
	speed_comp = get_node("SpeedComp")
	player = get_tree().get_first_node_in_group("player") as Player
	if !player:
		return
	player.teleported.connect(on_teleported)
	health_comp.died.connect(destroy)
	#print(health_comp.current_health)
func _process(_delta):
	hitbox_comp.emitter_position = global_position
	flip()

func _physics_process(delta):
	if stopped:
		velocity = Vector2.ZERO
		return
	if !knockback_comp.is_being_knocked:
		follow_player(delta)
	move_and_slide()
	
func follow_player(delta):
	if !player:
		return
	dir = (player.position-position).normalized()
	speed_comp.accelerate(delta)
	velocity = dir*speed_comp.current_speed


# Flips the sprite by scale
func flip():
	pass
	if sign(dir.x) > 0 && sprite.scale.x == -1:
		sprite.scale.x=1
	elif sign(dir.x) < 0 && sprite.scale.x==1:
		sprite.scale.x=-1

func on_teleported():
	speed_comp.current_speed = speed_reset

func destroy():
	queue_free()

func on_has_hit():
	print("has hit")
	stopped = true
	stop_timer.start()

func on_stop_timer_timeout():
	stopped = false

func on_knockback_finished():
	pass
