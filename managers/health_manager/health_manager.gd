extends Node

@export var hearts_container : HeartsContainer
var player : Player
var player_health_comp : HealthComp

func _ready():
	initialize()

func initialize():
	player = get_tree().get_first_node_in_group("player") as Player
	if !player:
		return
	player_health_comp = player.health as HealthComp
	player_health_comp.current_health = PlayerData.max_health
	player_health_comp.health_changed.connect(on_health_changed)
	player.last_breath_timer.timeout.connect(on_player_last_breath_timeout)
	if !hearts_container:
		return
	for num in PlayerData.max_health:
		hearts_container.add_heart()

func on_player_last_breath_timeout():
	get_tree().change_scene_to_file("res://ui/main_menu/main_menu.tscn")

func on_health_changed(amount):
	if amount < 0:
		for num in abs(amount):
			hearts_container.break_heart()
	else:
		for num in amount:
			hearts_container.add_heart()
