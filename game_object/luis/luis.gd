extends CharacterBody2D

@export var speed : float
var dir : Vector2

func _process(delta):
	dir = Input.get_vector("left","right","up","down")

func _physics_process(delta):
	velocity = dir.normalized()*speed
	move_and_slide()
