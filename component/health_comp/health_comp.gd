extends Node
class_name HealthComp

@export var max_health : int
var current_health : int
signal health_changed(amount : int)
signal died()

func _ready():
	current_health = max_health

func deal_damage(amount: int):
	current_health = max(current_health-amount,0)
	health_changed.emit(-amount)
	if current_health == 0:
		died.emit()

func heal(amount: int):
	current_health = min(current_health+amount,max_health)
	health_changed.emit(amount)
