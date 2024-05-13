extends Node
class_name KnockbackComp

@export var body : CharacterBody2D
const KNOCKBACK_DURATION : float = 0.2
var is_being_knocked : bool = false
var timer : Timer

func _ready():
	timer = get_node("Timer") as Timer
	timer.wait_time = KNOCKBACK_DURATION
	timer.timeout.connect(on_timeout)

func push(dir : Vector2, force : float):
	if !body:
		return
	is_being_knocked = true
	body.velocity = dir*force
	timer.start()

func on_timeout():
	body.velocity = Vector2.ZERO
	is_being_knocked = false
	
