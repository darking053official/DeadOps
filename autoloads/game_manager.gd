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
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://scenes/ui/game_over.tscn")

func reset() -> void:
	score = 0
	player_health = 100
