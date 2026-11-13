extends CanvasLayer

@onready var joystick: Control = $Joystick
@onready var fire_button: Panel = $FireButton
@onready var reload_button: Panel = $ReloadButton
@onready var score_label: Label = $ScoreLabel
@onready var health_label: Label = $HealthLabel

var _fire_touch: int = -1
var _reload_touch: int = -1

func _ready() -> void:
	var player := get_tree().get_first_node_in_group("player")
	if player:
		joystick.direction_changed.connect(player.set_move_input)

	GameManager.score_changed.connect(_on_score_changed)
	GameManager.health_changed.connect(_on_health_changed)
	_on_score_changed(GameManager.score)
	_on_health_changed(GameManager.player_health)

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		var fire_rect := fire_button.get_global_rect()
		var reload_rect := reload_button.get_global_rect()
		if event.pressed:
			if fire_rect.has_point(event.position) and _fire_touch == -1:
				_fire_touch = event.index
				_do_fire()
			elif reload_rect.has_point(event.position) and _reload_touch == -1:
				_reload_touch = event.index
				_do_reload()
		else:
			if event.index == _fire_touch:
				_fire_touch = -1
			if event.index == _reload_touch:
				_reload_touch = -1

func _do_fire() -> void:
	var player := get_tree().get_first_node_in_group("player")
	if player:
		player.shoot()

func _do_reload() -> void:
	print("Reload")

func _on_score_changed(new_score: int) -> void:
	score_label.text = "SCORE: " + str(new_score)

func _on_health_changed(new_hp: int) -> void:
	health_label.text = "HP: " + str(new_hp)
