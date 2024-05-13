extends Area2D
class_name Bullet

@export var rotate_speed : float
@export var player_dodge_bullet_sprite : Texture2D
var sprite : Sprite2D
var anim_player : AnimationPlayer
var hitbox_comp : HitboxComp
var speed_comp : SpeedComp
var dir : Vector2
var emiiter_pos : Vector2
var is_dodge_bullet : bool = false

func _ready():
	body_entered.connect(on_body_entered)
	sprite = $Sprite2D
	speed_comp = get_node("SpeedComp")
	anim_player = get_node("AnimationPlayer") as AnimationPlayer
	anim_player.play("decay")
	hitbox_comp = get_node("HitboxComp") as HitboxComp
	if is_dodge_bullet:
		become_dodge_bullet()
	hitbox_comp.has_hit.connect(destroy)
	hitbox_comp.emitter_position = emiiter_pos

func _physics_process(delta):
	speed_comp.deaccelerate(delta)
	position +=dir.normalized()*speed_comp.current_speed
	
func _process(delta):
	rotation_degrees += rotate_speed*delta
	if abs(speed_comp.current_speed) > 0:
		pass
	else:
		destroy()
	
func destroy():
	queue_free()
	
func become_dodge_bullet():
	hitbox_comp.monitoring = false
	sprite.texture = player_dodge_bullet_sprite
	
func on_body_entered(_body : Node2D):
	destroy()
