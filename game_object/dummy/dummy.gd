extends CharacterBody2D

var health_comp : HealthComp

func _ready():
	health_comp = $HealthComp as HealthComp
	print(health_comp.current_health)
