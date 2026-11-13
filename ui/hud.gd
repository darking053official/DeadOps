extends CanvasLayer

@onready var joystick: Control = $Joystick
@onready var fire_button: Panel = $FireButton
@onready var reload_button: Panel = $ReloadButton
@onready var score_label: Label = $ScoreLabel
@onready var health_label: Label = $HealthLabel

func _ready() -> void:
	var player := get_tree().get_first_node_in_group("player")
	if player:
		joystick.direction_changed.connect(player.set_move_input)

	fire_button.gui_input.connect(_on_fire_input)
	reload_button.gui_input.connect(_on_reload_input)

	GameManager.score_changed.connect(_on_score_changed)
	GameManager.health_changed.connect(_on_health_changed)
	_on_score_changed(GameManager.score)
	_on_health_changed(GameManager.player_health)

func _on_fire_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch and event.pressed:
		var player := get_tree().get_first_node_in_group("player")
		if player:
			player.shoot()

func _on_reload_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch and event.pressed:
		print("Reload")

func _on_score_changed(new_score: int) -> void:
	score_label.text = "SCORE: " + str(new_score)

func _on_health_changed(new_hp: int) -> void:
	health_label.text = "HP: " + str(new_hp)
