extends Node
class_name CameraShakeManager

@export var starting_shake_strength : float = 7.5
@export var shake_fade : float = 20
@export var camera : Camera2D
var player : Player

var rng : RandomNumberGenerator

var shake_strength = 0

func _ready():
	rng = RandomNumberGenerator.new()
	player = get_tree().get_first_node_in_group("player") as Player
	player.player_hurt.connect(on_player_hurt)
	
func _process(delta):
	if !camera:
		return
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength,0,delta*shake_fade)
		camera.offset = get_random_offset()

func apply_shake():
	shake_strength = starting_shake_strength

func get_random_offset() -> Vector2:
	var random_offset = Vector2(
		rng.randf_range(-shake_strength,shake_strength),
		rng.randf_range(-shake_strength,shake_strength)
	)
	return random_offset

func on_player_hurt():
	apply_shake()
