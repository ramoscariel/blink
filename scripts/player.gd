extends CharacterBody2D
class_name Player

const TELEPORT_VEL_PERCENT := 0.9

@export var bullet : PackedScene
@export var vanish_effect : PackedScene
@export var shoot_wait_interval : float
@export var teleport_duration : float

var bullet_origin : Node2D
var sprite : Sprite2D
var shoot_audio_player : AudioStreamPlayer2D
var pop_audio_player : AudioStreamPlayer2D
var anim_player : AnimationPlayer
var invincibility_anim : AnimationPlayer
var shoot_timer : Timer
var min_time_in_atk_anim : Timer
var last_breath_timer : Timer
var invincibility_timer : Timer
var last_bullet : Node2D
var hurtbox : HurtboxComp
var health : HealthComp

var target_velocity : Vector2 = Vector2.ZERO

var teleport_time_remaining : float

var can_shoot : bool = true
var is_teleporting : bool = true
var dodge_bullet_active : bool = false

signal teleported

func _enter_tree():
	bullet_origin = $BulletOrigin
	sprite = $Sprite2D
	shoot_audio_player = $ShootAudioPlayer
	pop_audio_player = $PopAudioPlayer
	
	invincibility_anim = $InvincibilityAnim
	
	anim_player = $AnimationPlayer as AnimationPlayer
	anim_player.animation_finished.connect(on_animation_finished)
	
	health = $HealthComp as HealthComp
	health.died.connect(on_died)
	
	hurtbox = $HurtboxComp as HurtboxComp
	hurtbox.has_been_hit.connect(on_has_been_hit)
	
	shoot_timer = $ShootTimer as Timer
	shoot_timer.timeout.connect(on_shoot_timer_timeout)
	shoot_timer.wait_time = shoot_wait_interval
	
	min_time_in_atk_anim = $MinTimeInAtkAnim as Timer
	min_time_in_atk_anim.timeout.connect(on_min_time_in_atk_anim_timeout)
	
	last_breath_timer = $LastBreathTimer as Timer
	last_breath_timer.timeout.connect(on_last_breath_timer_timeout)
	
	invincibility_timer = $InvincibilityTimer as Timer
	invincibility_timer.timeout.connect(on_invincibility_timer_timeout)
	
func _physics_process(delta):
	if is_teleporting:
		velocity = target_velocity
		teleport_time_remaining -= delta
		if teleport_time_remaining < 0:
			velocity = Vector2.ZERO
			is_teleporting = false
			teleported.emit()
			activate_teleport(false)
	move_and_slide()

func _process(_delta):
	activate_dodge_bullet()
	look_at_mouse()
	fire()
	teleport()

func look_at_mouse():
	var dir_to_mouse = get_global_mouse_position()-global_position
	if dir_to_mouse.x > 0 && sprite.flip_h:
		sprite.flip_h = false
	elif dir_to_mouse.x < 0 && !sprite.flip_h:
		sprite.flip_h = true

func activate_dodge_bullet():
	if Input.is_action_just_pressed("dodge"):
		dodge_bullet_active = true

func fire():
	if Input.is_action_pressed("fire") && can_shoot:
		can_shoot = false
		anim_player.play("attack")
		shoot_timer.start()
		min_time_in_atk_anim.start()
		instantiate_bullet()
		dodge_bullet_active = false

func teleport():
	if Input.is_action_just_pressed("tp"):
		if !last_bullet:
			return
		instantiate_vanish()
		last_bullet.queue_free()
		is_teleporting = true
		activate_teleport(true)
		teleport_time_remaining = teleport_duration
		target_velocity = calculate_velocity(position,last_bullet.position)
		pop_audio_player.play()

func calculate_velocity(current_pos : Vector2, target_pos : Vector2)->Vector2:
	var displacement = target_pos - current_pos
	var target_vel = displacement / teleport_duration
	return target_vel*TELEPORT_VEL_PERCENT	

func activate_teleport(value : bool):
	sprite.visible = !value
	hurtbox.set_invincibility(value)

func instantiate_bullet():
	var bullet_instance = bullet.instantiate() as Bullet
	var spawn_pos = bullet_origin.global_position
	var spawn_dir = (get_global_mouse_position()-global_position).normalized()
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

func instantiate_vanish():
	var vansih_sprite := vanish_effect.instantiate() as Sprite2D
	vansih_sprite.frame = sprite.frame
	vansih_sprite.skew = sprite.skew
	vansih_sprite.offset = sprite.offset
	vansih_sprite.rotation = sprite.rotation
	vansih_sprite.global_position = global_position
	get_parent().add_child(vansih_sprite)

func on_shoot_timer_timeout():
	can_shoot = true

func on_min_time_in_atk_anim_timeout():
	anim_player.play("idle")

func on_has_been_hit():
	anim_player.play("hurt")
	hurtbox.call_deferred("set_invincibility",true)
	invincibility_timer.start()
	invincibility_anim.play("inv")
	print("inv_started")

func on_animation_finished(anim_name : StringName):
	if anim_name == "hurt":
		anim_player.play("idle")

func on_died():
	last_breath_timer.start()
	
func on_last_breath_timer_timeout():
	queue_free()

func on_invincibility_timer_timeout():
	hurtbox.call_deferred("set_invincibility",false)
	invincibility_anim.play("not_inv")
	print("inv_finished")
	
