extends Node

@export var hearts_container : HeartsContainer
var current_health : int
var player : Player
var player_health_comp : HealthComp

func _ready():
	current_health = PlayerData.max_health
	player = get_tree().get_first_node_in_group("player") as Player
	player_health_comp = player.health_comp as HealthComp
	player_health_comp.current_health = current_health
	player_health_comp.health_changed.connect(on_health_changed)
	player_health_comp.died.connect(on_died)
	if !hearts_container:
		return
	for num in PlayerData.max_health:
		hearts_container.add_heart()

func on_died():
	player.destroy()

func on_health_changed(amount):
	if amount < 0:
		for num in abs(amount):
			hearts_container.break_heart()
	else:
		for num in amount:
			hearts_container.add_heart()
