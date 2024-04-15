extends CharacterBody2D
class_name Player

enum PlayerStates {IDLE,SHOOTING}
var current_state : PlayerStates = PlayerStates.IDLE
var sprite : Sprite2D
var time_in_attack_anim : Timer
var shoot_wait_interval : Timer
var knockback_comp : KnockbackComp
var animation_player : AnimationPlayer
var bullet : PackedScene
var shoot_audio_player : AudioStreamPlayer2D
var pop_audio_player : AudioStreamPlayer2D
var hurtbox_comp : HurtboxComp
var health_comp : HealthComp
var bullet_origin : Node2D
var mouse_pos : Vector2
var last_bullet : Bullet = null
var can_shoot : bool = true
var dodge_bullet_active : bool = false 
@export var invincibility_duration : float

signal teleported()

func _enter_tree():
	hurtbox_comp = $HurtboxComp as HurtboxComp
	hurtbox_comp.has_been_hit.connect(on_has_been_hit)
	time_in_attack_anim =$TimeInAtkAnim as Timer
	time_in_attack_anim.timeout.connect(on_time_in_atk_anim_timeout)
	animation_player = get_node("AnimationPlayer") as AnimationPlayer
	animation_player.animation_finished.connect(on_anim_finished)
	sprite = $Sprite2D
	shoot_wait_interval = $ShootWaitInterval as Timer
	shoot_wait_interval.timeout.connect(on_shoot_wait_interval_timeout)
	health_comp = get_node("HealthComp") as HealthComp
	knockback_comp = $KnockbackComp as KnockbackComp

func _ready():
	print(health_comp.max_health)
	
	shoot_audio_player = get_node("ShootAudioPlayer") as AudioStreamPlayer2D
	pop_audio_player = get_node("PopAudioPlayer") as AudioStreamPlayer2D
	bullet_origin = get_node("BulletOrigin") as Node2D
	bullet = preload("res://game_object/bullet/bullet.tscn")
	
	
func _physics_process(delta):
	if !knockback_comp.is_being_knocked:
		velocity = Vector2.ZERO
	move_and_slide()	

func _process(_delta):
	activate_dodge_bullet()
	aim()
	fire()
	teleport()

func aim():
	mouse_pos =get_global_mouse_position()
	look_at_mouse()

# Flips the sprite horizontally based on mouse_pos
func look_at_mouse():
	var dir_to_mouse = (mouse_pos-global_position).normalized()
	if dir_to_mouse.x > 0 && sprite.flip_h:
		sprite.flip_h = false
	elif dir_to_mouse.x < 0 && !sprite.flip_h:
		sprite.flip_h = true

func change_to_idle():
	if Input.is_action_just_released("fire"):
		animation_player.play("idle")
	
func destroy():
	queue_free()
	
func fire():
	if Input.is_action_pressed("fire") && can_shoot:
		can_shoot = false
		shoot_wait_interval.start()
		animation_player.play("attack")
		time_in_attack_anim.start()
		instantiate_bullet()
		dodge_bullet_active = false

func teleport():
	if Input.is_action_just_pressed("tp"):
		if last_bullet == null:
			return
		position = last_bullet.position
		pop_audio_player.play()
		last_bullet.destroy()
		teleported.emit()

func activate_dodge_bullet():
	if Input.is_action_just_pressed("dodge"):
		activate_invincibility()
		dodge_bullet_active = true

func on_has_been_hit():
	animation_player.play("damaged")

func on_time_in_atk_anim_timeout():
	animation_player.play("idle")

func on_shoot_wait_interval_timeout():
	can_shoot = true

# Instantiates a bullet or a dodge bullet if dodge_bullet_active is true
func instantiate_bullet():
	var bullet_instance = bullet.instantiate() as Bullet
	var spawn_pos = bullet_origin.global_position
	var spawn_dir = (mouse_pos-global_position).normalized()
	var spawn_rotation_deg = rad_to_deg(spawn_dir.angle())
	bullet_instance.global_position = spawn_pos
	bullet_instance.dir = spawn_dir
	bullet_instance.rotation_degrees += spawn_rotation_deg
	bullet_instance.emiiter_pos = global_position
	if dodge_bullet_active:
		bullet_instance.is_dodge_bullet = true
	get_parent().add_child(bullet_instance)
	last_bullet = bullet_instance
	shoot_audio_player.play()

func activate_invincibility():
	hurtbox_comp.monitorable = false

func on_anim_finished(anim_name):
	if anim_name == "damaged":
		animation_player.play("idle")
