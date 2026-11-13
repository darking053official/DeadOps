extends Node3D

@export var hud_scene: PackedScene

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	GameManager.reset()

	var hud := CanvasLayer.new()
	if hud_scene:
		hud = hud_scene.instantiate()
	else:
		var hud_packed: PackedScene = load("res://ui/hud.tscn")
		hud = hud_packed.instantiate()
	add_child(hud)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
