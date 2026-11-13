extends Node3D

@export var hud_scene: PackedScene
@export var player_scene: PackedScene

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	GameManager.reset()

	# Fallback: sahnede atanmamışsa kodla yükle
	if not player_scene:
		player_scene = load("res://scenes/actors/player/player.tscn")
	if not hud_scene:
		hud_scene = load("res://ui/hud.tscn")

	var hud := hud_scene.instantiate()
	add_child(hud)

	if multiplayer.multiplayer_peer:
		if multiplayer.is_server():
			_spawn_player(1)
			multiplayer.peer_connected.connect(_on_peer_connected)
		else:
			_spawn_player(multiplayer.get_unique_id())

func _spawn_player(id: int) -> void:
	var p := player_scene.instantiate()
	p.peer_id = id
	p.name = "Player_" + str(id)
	add_child(p)

func _on_peer_connected(id: int) -> void:
	_spawn_player(id)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
