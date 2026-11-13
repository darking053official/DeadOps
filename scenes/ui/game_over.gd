extends Control

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	$ScoreLabel.text = "SKOR: " + str(GameManager.score)
	$RetryButton.pressed.connect(_on_retry)
	$MenuButton.pressed.connect(_on_menu)

func _on_retry() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/game_level.tscn")

func _on_menu() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
