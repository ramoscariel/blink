extends MarginContainer
class_name LevelUpMenu

@onready var button = $MarginContainer/Button as Button
func _ready():
	button.button_down.connect(on_button_down)
	pause()

func pause():
	get_tree().paused = true

func resume():
	get_tree().paused = false
	queue_free()

func on_button_down():
	resume()
