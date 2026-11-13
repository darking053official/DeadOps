extends CharacterBody3D

@export var max_health: float = 100.0
@export var speed: float = 3.0
@export var detection_range: float = 30.0
@export var attack_range: float = 15.0
@export var attack_damage: float = 10.0
@export var attack_cooldown: float = 1.5

var health: float
var attack_timer := 0.0
var player: Node3D

@onready var agent: NavigationAgent3D = $NavigationAgent3D
@onready var vision_ray: RayCast3D = $VisionRay

func _ready() -> void:
	health = max_health
	add_to_group("enemy")
	player = get_tree().get_first_node_in_group("player")
	set_physics_process(true)

func _physics_process(delta: float) -> void:
	if not player or health <= 0:
		return

	var distance := global_position.distance_to(player.global_position)
	attack_timer = max(0.0, attack_timer - delta)

	if distance > detection_range:
		velocity = Vector3.ZERO
		return

	if distance > attack_range:
		# Takip et
		agent.target_position = player.global_position
		var next := agent.get_next_path_position()
		var dir := (next - global_position).normalized()
		velocity = dir * speed
		move_and_slide()
	else:
		# Ateş et
		velocity = Vector3.ZERO
		_look_at_player()
		if attack_timer <= 0.0:
			_attack()
			attack_timer = attack_cooldown

func _look_at_player() -> void:
	var target := player.global_position
	target.y = global_position.y
	if global_position.distance_to(target) > 0.1:
		look_at(target, Vector3.UP)

func _attack() -> void:
	if not player:
		return
	if player.has_method("take_damage"):
		player.take_damage(attack_damage)
	elif GameManager:
		GameManager.damage_player(int(attack_damage))

func take_damage(amount: float) -> void:
	health -= amount
	if health <= 0:
		die()

func die() -> void:
	GameManager.add_score(10)
	queue_free()
