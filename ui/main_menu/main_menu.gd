extends CanvasLayer

var play_button : Button
var exit_button : Button

func _ready():
	play_button = %PlayButton as Button
	play_button.pressed.connect(on_play_pressed)
	
	exit_button = %ExitButton as Button
	exit_button.pressed.connect(on_exit_pressed)
	
func on_play_pressed():
	get_tree().change_scene_to_file("res://main/main.tscn")
	
func on_exit_pressed():
	get_tree().quit()
