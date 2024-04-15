extends Node
class_name KnockbackComp

@export var body : CharacterBody2D
@export var knockback_duration : float = 0.2
var is_being_knocked : bool = false
var timer : Timer
signal knockback_finished()

func _ready():
	timer = get_node("Timer") as Timer
	timer.wait_time = knockback_duration
	timer.timeout.connect(on_timeout)

func push(dir : Vector2, force : float):
	if !body:
		return
	is_being_knocked = true
	body.velocity = dir*force
	timer.start()

func on_timeout():
	is_being_knocked = false
	knockback_finished.emit()
	
