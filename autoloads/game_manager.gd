extends Node

var score: int = 0
var player_health: int = 100

signal score_changed(new_score: int)
signal health_changed(new_health: int)

func add_score(amount: int) -> void:
	score += amount
	score_changed.emit(score)

func damage_player(amount: int) -> void:
	player_health = max(0, player_health - amount)
	health_changed.emit(player_health)
	if player_health <= 0:
		game_over()

func game_over() -> void:
	get_tree().reload_current_scene()

func reset() -> void:
	score = 0
	player_health = 100
