extends Node
class_name LevelUpManager

@export var xp_bar : ProgressBar
@export var pickable_collector : PickableCollector
@export var canvas_layer : CanvasLayer
@onready var level_up_menu_scene = preload("res://ui/level_up_menu/level_up_menu.tscn")

func _ready():
	if !pickable_collector || !xp_bar:
		return
	PlayerData.leveled_up.connect(on_leveled_up)
	pickable_collector.area_entered.connect(on_pickable_collector_area_entered)
	xp_bar.value = 0

func on_pickable_collector_area_entered(area : Area2D):
	var xp = area as Xp
	PlayerData.add_xp(xp.collect())
	xp_bar.value = (PlayerData.xp*100)/PlayerData.xp_to_next_level

func on_leveled_up():
	var level_up_menu = level_up_menu_scene.instantiate() as LevelUpMenu
	canvas_layer.add_child(level_up_menu)
