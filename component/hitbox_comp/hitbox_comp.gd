extends Area2D
class_name HitboxComp

@export var damage : float 
@export var knockback_force : float = 50
var emitter_position : Vector2

signal has_hit

func _ready():
	area_entered.connect(on_area_entered)

func on_area_entered(area : Area2D):
	check_hurtbox(area)
	
func check_hurtbox(area : Area2D):
	var hurtbox = area as HurtboxComp
	if hurtbox.invincibility:
		print("is invincible")
		return
	hurtbox.deal_damage(damage)
	has_hit.emit()
	var dir = (hurtbox.global_position - emitter_position).normalized()
	hurtbox.apply_knockback(dir,knockback_force)
