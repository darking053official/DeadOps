extends Control

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	$PlayButton.pressed.connect(_on_play)
	$QuitButton.pressed.connect(_on_quit)

func _on_play() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/game_level.tscn")

func _on_quit() -> void:
	get_tree().quit()
