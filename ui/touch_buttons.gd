extends Control

signal fire_pressed
signal reload_pressed

func _ready() -> void:
	$FireButton.pressed.connect(func(): fire_pressed.emit())
	$ReloadButton.pressed.connect(func(): reload_pressed.emit())
