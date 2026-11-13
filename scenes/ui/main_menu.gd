extends Control

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	$SingleButton.pressed.connect(_on_single)
	$HostButton.pressed.connect(_on_host)
	$JoinButton.pressed.connect(_on_join)
	NetworkManager.player_list_changed.connect(_on_player_list_changed)

func _get_name() -> String:
	var n := $NameInput.text.strip_edges()
	return n if n != "" else "Player"

func _on_single() -> void:
	NetworkManager.is_host = false
	NetworkManager.multiplayer.multiplayer_peer = null
	get_tree().change_scene_to_file("res://scenes/levels/game_level.tscn")

func _on_host() -> void:
	$StatusLabel.text = "Sunucu açılıyor..."
	NetworkManager.host_game(_get_name())

func _on_join() -> void:
	var ip := $IPInput.text.strip_edges()
	if ip == "":
		$StatusLabel.text = "IP gir!"
		return
	$StatusLabel.text = "Bağlanılıyor: " + ip
	NetworkManager.join_game(ip, _get_name())

func _on_player_list_changed() -> void:
	$StatusLabel.text = "Oyuncular: " + str(NetworkManager.peers.size())
