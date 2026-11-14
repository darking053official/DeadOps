extends Control

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	$SkorEtiketi.text = "skor: " + str(GameManager.score)
	$TekrarButonu.pressed.connect(_tekrar_oyna)
	$MenuButonu.pressed.connect(_ana_menu)

func _tekrar_oyna() -> void:
	if GameManager.secili_harita == "":
		GameManager.secili_harita = "res://scenes/levels/harita_1.tscn"
	get_tree().change_scene_to_file(GameManager.secili_harita)

func _ana_menu() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
