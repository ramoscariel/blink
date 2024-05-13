extends State
class_name ArcherState

var player : Node2D
var dir_to_player : Vector2 # Not normalized

@export var move_speed : float

@export var hit_flash_anim_player : AnimationPlayer
@export var sprite : Sprite2D
@export var character_body : CharacterBody2D
@export var last_breath_timer : Timer
@export var knockback_comp : KnockbackComp
@export var hurtbox_comp : HurtboxComp
@export var health_comp : HealthComp

func enter() -> void:
	player = get_tree().get_first_node_in_group("player")
	last_breath_timer.timeout.connect(on_last_breath_timer_timeout)
	health_comp.died.connect(on_health_comp_died)
	hurtbox_comp.has_been_hit.connect(on_hurtbox_comp_has_been_hit)

func exit() -> void:
	last_breath_timer.timeout.disconnect(on_last_breath_timer_timeout)
	health_comp.died.disconnect(on_health_comp_died)
	hurtbox_comp.has_been_hit.disconnect(on_hurtbox_comp_has_been_hit)

func update(_delta) -> void:
	get_dir_to_player()
	flip()

func destroy():
	character_body.queue_free()

func get_dir_to_player():
	if !player:
		return
	dir_to_player = (player.global_position-character_body.global_position)

func flip():
	if !sprite:
		return
	if sign(dir_to_player.x) > 0 && sprite.scale.x == -1:
		sprite.scale.x=1
	elif sign(dir_to_player.x) < 0 && sprite.scale.x==1:
		sprite.scale.x=-1

func on_health_comp_died():
	last_breath_timer.start()

func on_hurtbox_comp_has_been_hit():
	if !hit_flash_anim_player:
		return
	hit_flash_anim_player.play("hit_flash")
	
func on_last_breath_timer_timeout():
	destroy()
