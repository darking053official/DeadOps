extends Node

var score: int = 0
var player_health: int = 100
var scores: Dictionary = {}
var secili_harita: String = "res://scenes/levels/harita_1.tscn"

signal score_changed(new_score: int)
signal health_changed(new_health: int)
signal scores_updated(all_scores: Dictionary)

func add_score(amount: int) -> void:
	score += amount
	score_changed.emit(score)
	if multiplayer.multiplayer_peer and not multiplayer.is_server():
		_add_score_rpc.rpc_id(1, amount)

@rpc("any_peer", "reliable")
func _add_score_rpc(amount: int) -> void:
	var id := multiplayer.get_remote_sender_id()
	scores[id] = scores.get(id, 0) + amount
	scores_updated.emit(scores)

func damage_player(amount: int) -> void:
	player_health = max(0, player_health - amount)
	health_changed.emit(player_health)
	if player_health <= 0:
		game_over()

func game_over() -> void:
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://scenes/ui/game_over.tscn")

func reset() -> void:
	score = 0
	player_health = 100
	scores.clear()
