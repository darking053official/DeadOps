extends WeaponBase

@onready var muzzle: Node3D = $Muzzle

func _perform_shot() -> void:
	super._perform_shot()
	_flash_muzzle()

func _flash_muzzle() -> void:
	if not muzzle:
		return
	var light := OmniLight3D.new()
	light.light_color = Color(1, 0.8, 0.3)
	light.light_energy = 3.0
	light.omni_range = 5.0
	muzzle.add_child(light)
	await get_tree().create_timer(0.05).timeout
	light.queue_free()
