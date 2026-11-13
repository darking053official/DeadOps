extends Node

const PORT := 7777
const MAX_PLAYERS := 4

var peers: Dictionary = {}
var is_host := false

signal player_list_changed

func host_game(player_name: String) -> void:
	var peer := ENetMultiplayerPeer.new()
	var err := peer.create_server(PORT, MAX_PLAYERS)
	if err != OK:
		push_error("sunucu oluşturulamadı: %s" % err)
		return
	multiplayer.multiplayer_peer = peer
	is_host = true
	peers[1] = player_name
	_connect_signals()
	player_list_changed.emit()
	change_to_game()

func join_game(ip: String, player_name: String) -> void:
	var peer := ENetMultiplayerPeer.new()
	var err := peer.create_client(ip, PORT)
	if err != OK:
		push_error("bağlanılamadı: %s" % err)
		return
	multiplayer.multiplayer_peer = peer
	is_host = false
	_connect_signals()

func _connect_signals() -> void:
	if not multiplayer.peer_connected.is_connected(_on_peer_connected):
		multiplayer.peer_connected.connect(_on_peer_connected)
	if not multiplayer.peer_disconnected.is_connected(_on_peer_disconnected):
		multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	if not multiplayer.connected_to_server.is_connected(_on_connected_to_server):
		multiplayer.connected_to_server.connect(_on_connected_to_server)

func _on_peer_connected(id: int) -> void:
	if is_host:
		peers[id] = "oyuncu%d" % id
		player_list_changed.emit()
		_sync_player_list.rpc(peers)

func _on_peer_disconnected(id: int) -> void:
	peers.erase(id)
	player_list_changed.emit()

func _on_connected_to_server() -> void:
	_register_player.rpc_id(1, "oyuncu%d" % multiplayer.get_unique_id())

@rpc("any_peer", "reliable")
func _register_player(player_name: String) -> void:
	var id := multiplayer.get_remote_sender_id()
	peers[id] = player_name
	player_list_changed.emit()
	_sync_player_list.rpc(peers)

@rpc("authority", "reliable")
func _sync_player_list(new_peers: Dictionary) -> void:
	peers = new_peers
	player_list_changed.emit()

func change_to_game() -> void:
	get_tree().change_scene_to_file(GameManager.secili_harita)
