extends Area2D
class_name Xp

@export var little_xp_sprite : Texture
@export var big_xp_sprite : Texture
@onready var sprite = $Sprite2D

var keys = ["little","little","little","little","big"]

var xp_amount : int

#Array: first value xp amount, second sprite
var xp_dict = {"little": [1,null], "big": [5,null]}

func _ready():
	if !little_xp_sprite || !big_xp_sprite:
		return
	xp_dict["little"][1] = little_xp_sprite 
	xp_dict["big"][1] = big_xp_sprite
	initialize()

func initialize():
	var key = keys.pick_random()
	xp_amount = xp_dict[key][0]
	sprite.texture = xp_dict[key][1]
	
func collect()->int:
	queue_free()
	return xp_amount
