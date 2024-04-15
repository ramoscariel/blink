extends Area2D
class_name HitboxComp

@export var damage : float 
@export var applies_knockback : bool
@export var knockback_force : float
var emitter_position : Vector2

signal has_hit

func _ready():
	area_entered.connect(on_area_entered)

func on_area_entered(area : Area2D):
	var hurtbox = area as HurtboxComp
	hurtbox.deal_damage(damage)
	has_hit.emit()
	if !applies_knockback:
		return
	var dir = (hurtbox.global_position - emitter_position).normalized()
	hurtbox.apply_knockback(dir,knockback_force)
	
