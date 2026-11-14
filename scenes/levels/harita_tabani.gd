extends Node3D

@export var hud_scene: PackedScene
@export var player_scene: PackedScene
@export var dusman_scene: PackedScene
@export var dusman_sayisi: int = 4
@export var spawn_noktalari: Array[Vector3] = []

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	GameManager.reset()

	if not player_scene:
		player_scene = load("res://scenes/actors/player/player.tscn")
	if not hud_scene:
		hud_scene = load("res://ui/hud.tscn")
	if not dusman_scene:
		dusman_scene = load("res://scenes/enemies/enemy.tscn")

	var hud = hud_scene.instantiate()
	add_child(hud)

	_dusmanlari_yerlestir()

	if multiplayer.multiplayer_peer and not multiplayer.is_server():
		_oyuncu_olustur(multiplayer.get_unique_id())
	else:
		_oyuncu_olustur(1)
		if multiplayer.multiplayer_peer:
			multiplayer.peer_connected.connect(_oyuncu_olustur)

func _oyuncu_olustur(id: int) -> void:
	var oyuncu = player_scene.instantiate()
	oyuncu.peer_id = id
	oyuncu.name = "Oyuncu_" + str(id)
	oyuncu.position = Vector3(0, 1, 0)
	add_child(oyuncu)

func _dusmanlari_yerlestir() -> void:
	if not multiplayer.multiplayer_peer or multiplayer.is_server():
		for i in range(dusman_sayisi):
			var nokta := Vector3(randf_range(-25, 25), 1, randf_range(-25, 25))
			if spawn_noktalari.size() > 0 and i < spawn_noktalari.size():
				nokta = spawn_noktalari[i]
			var dusman = dusman_scene.instantiate()
			dusman.position = nokta
			add_child(dusman)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
