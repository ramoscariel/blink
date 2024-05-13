extends Node
class_name HealthComp

@export var max_health : float
var current_health : float
signal health_changed(amount : float)
signal died()

func _ready():
	current_health = max_health

func deal_damage(amount: float):
	current_health = max(current_health-amount,0)
	health_changed.emit(-amount)
	if current_health == 0:
		died.emit()

func heal(amount: float):
	current_health = min(current_health+amount,max_health)
	health_changed.emit(amount)
