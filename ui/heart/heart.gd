extends Control
class_name Heart

var anim_player : AnimationPlayer

func _enter_tree():
	anim_player = $AnimationPlayer as AnimationPlayer
	anim_player.animation_finished.connect(on_animation_finished)
	
func play_anim(anim_name : StringName):
	anim_player.play(anim_name)

func destroy():
	queue_free()

func on_animation_finished(_anim_name):
	anim_player.play("idle")
