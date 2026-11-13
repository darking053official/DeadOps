extends CanvasLayer

@onready var joystick: Control = $Joystick
@onready var ates_butonu: TouchScreenButton = $AtesButonu
@onready var sarjor_butonu: TouchScreenButton = $SarjorButonu
@onready var skor_etiketi: Label = $SkorEtiketi
@onready var can_etiketi: Label = $CanEtiketi

func _ready() -> void:
	var oyuncu := get_tree().get_first_node_in_group("player")
	if oyuncu:
		joystick.yon_degisti.connect(oyuncu.set_move_input)

	ates_butonu.pressed.connect(_ates_et)
	sarjor_butonu.pressed.connect(_sarjor_degistir)

	GameManager.score_changed.connect(_skor_degisti)
	GameManager.health_changed.connect(_can_degisti)
	_skor_degisti(GameManager.score)
	_can_degisti(GameManager.player_health)

func _ates_et() -> void:
	var oyuncu := get_tree().get_first_node_in_group("player")
	if oyuncu:
		oyuncu.shoot()

func _sarjor_degistir() -> void:
	print("şarjör değiştiriliyor")

func _skor_degisti(yeni_skor: int) -> void:
	skor_etiketi.text = "skor: " + str(yeni_skor)

func _can_degisti(yeni_can: int) -> void:
	can_etiketi.text = "can: " + str(yeni_can)
