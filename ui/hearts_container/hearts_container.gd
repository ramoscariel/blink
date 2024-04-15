extends MarginContainer
class_name HeartsContainer

var grid_container : GridContainer
var heart_scene : PackedScene

func _ready():
	grid_container = $MarginContainer/GridContainer
	heart_scene = preload("res://ui/heart/heart.tscn")

func add_heart():
	var heart_instance = heart_scene.instantiate() as Heart
	grid_container.add_child(heart_instance)
	heart_instance.play_anim("appear")

func break_heart():
	if grid_container.get_child_count() == 0:
		return
	var heart_to_anim = grid_container.get_child(-1) as Heart
	heart_to_anim.play_anim("break")
	
