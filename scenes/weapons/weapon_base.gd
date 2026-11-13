class_name WeaponBase
extends Node3D

@export var damage: float = 25.0
@export var fire_rate: float = 0.2
@export var range: float = 100.0
@export var enemy_layer: int = 2

var can_fire := true

func fire() -> void:
	if not can_fire:
		return
	can_fire = false
	_perform_shot()
	await get_tree().create_timer(fire_rate).timeout
	can_fire = true

func _perform_shot() -> void:
	var camera: Camera3D = get_viewport().get_camera_3d()
	if not camera:
		return

	var origin := camera.global_position
	var end := origin + (-camera.global_transform.basis.z) * range

	var query := PhysicsRayQueryParameters3D.create(origin, end)
	query.collision_mask = enemy_layer
	query.exclude = [get_parent().get_parent()]

	var result := get_world_3d().direct_space_state.intersect_ray(query)
	if result and result.collider.has_method("take_damage"):
		result.collider.take_damage(damage)
