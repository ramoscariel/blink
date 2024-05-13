extends Area2D
class_name HurtboxComp

@export var health_comp : HealthComp
@export var knockback_comp : KnockbackComp

var invincibility : bool = false

signal has_been_hit()

func deal_damage(amount : float):
	if !health_comp:
		return
	health_comp.deal_damage(amount)
	has_been_hit.emit()

func apply_knockback(dir : Vector2, force: float):
	knockback_comp.push(dir,force)

func heal(amount : float):
	if !health_comp:
		return
	health_comp.heal(amount)

func set_invincibility(value : bool):
	invincibility = value
		
