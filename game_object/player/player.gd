extends CharacterBody2D
class_name PlayerD

var teleport_duration := 0.2
var teleport_time_remaining : float
const ADJUST_MAGNITUDE := 20
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
var target_position : Vector2
var can_shoot : bool = true
var dodge_bullet_active : bool = false 
@export var teleport_speed : float = 700
@export var invincibility_duration : float
var teleport_wait_interval : Timer
var is_teleporting : bool = false
var can_teleport : bool = true
var vanish_effect : PackedScene
var target_velocity : Vector2 = Vector2.ZERO

signal teleported()

func _enter_tree():
	teleport_wait_interval = $TeleportWaitInterval as Timer
	teleport_wait_interval.wait_time = teleport_duration
	teleport_wait_interval.timeout.connect(on_tmdt_timeout)
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
	vanish_effect = preload("res://sfx/wizard_vanish/wizard_vanish.tscn")

func _ready():
	shoot_audio_player = get_node("ShootAudioPlayer") as AudioStreamPlayer2D
	pop_audio_player = get_node("PopAudioPlayer") as AudioStreamPlayer2D
	bullet_origin = get_node("BulletOrigin") as Node2D
	bullet = preload("res://game_object/bullet/bullet.tscn")
	
	
func _physics_process(delta):
	if is_teleporting:
		if teleport_time_remaining > 0:
			teleport_time_remaining-= delta
		else:
			is_teleporting = false
			velocity = Vector2.ZERO
	move_and_slide()

func _process(_delta):
	activate_dodge_bullet()
	aim()
	fire()
	teleport()

func start_teleport(vel : Vector2):
	sprite.visible = false
	set_invincibility(true)
	velocity = vel

func stop_teleport():
	velocity = Vector2.ZERO  
	set_invincibility(false)
	sprite.visible=true

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
		#teleport_wait_interval.start()
		#can_teleport = false
		spawn_vanish()
		target_position = last_bullet.position
		is_teleporting = true
		teleport_time_remaining = teleport_duration
		target_velocity = calculate_velocity(position,target_position,teleport_duration)
		velocity = target_velocity
		#teleport_wait_interval.start()
		#start_teleport(calculate_velocity(position,target_position))
		pop_audio_player.play()
		last_bullet.destroy()
		#teleported.emit()

func spawn_vanish():
	var vansih_sprite := vanish_effect.instantiate() as Sprite2D
	vansih_sprite.frame = sprite.frame
	vansih_sprite.skew = sprite.skew
	vansih_sprite.offset = sprite.offset
	vansih_sprite.rotation = sprite.rotation
	vansih_sprite.global_position = global_position
	get_parent().add_child(vansih_sprite)

func activate_dodge_bullet():
	if Input.is_action_just_pressed("dodge"):
		#activate_invincibility()
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

func set_invincibility(value : bool):
	hurtbox_comp.monitorable = !value

func on_anim_finished(anim_name):
	if anim_name == "damaged":
		animation_player.play("idle")

func on_tmdt_timeout():
	stop_teleport()

func calculate_velocity(current_pos : Vector2, target_pos : Vector2, time : float)->Vector2:
	# Calculate the displacement vector to the target
	var displacement = target_pos - current_pos
	var target_velocity = displacement / time
	return target_velocity*0.9
