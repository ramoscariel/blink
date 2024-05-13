extends Node2D
class_name Spawner

@export var time_to_spawn : float
@export var entities : Array[PackedScene]
var visible_on_screen_notifier : VisibleOnScreenNotifier2D
var spawn_entity_timer : Timer

func _ready():
	visible_on_screen_notifier = $VisibleOnScreenNotifier2D
	spawn_entity_timer = $SpawnEntityTimer as Timer
	spawn_entity_timer.timeout.connect(on_timeout)
	spawn_entity_timer.wait_time = time_to_spawn

func on_timeout():
	if entities.size() < 1:
		return
	if visible_on_screen_notifier.is_on_screen():
		return
	var scene = entities.pick_random() as PackedScene
	var entity = scene.instantiate() as Node2D
	entity.position = position
	get_parent().add_child(entity)
