extends Control

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	var secim = $Panel/HaritaSecimi
	secim.clear()
	secim.add_item("şehir", 0)
	secim.add_item("depo", 1)
	secim.add_item("çöl", 2)
	secim.select(0)
	secim.item_selected.connect(_harita_secildi)
	_harita_secildi(0)

	$Panel/TekButonu.pressed.connect(_tek_oyuncu)
	$Panel/SunucuButonu.pressed.connect(_sunucu_ac)
	$Panel/BaglanButonu.pressed.connect(_baglan)
	NetworkManager.player_list_changed.connect(_oyuncu_listesi_degisti)

func _harita_secildi(index: int) -> void:
	var haritalar := [
		"res://scenes/levels/harita_1.tscn",
		"res://scenes/levels/harita_2.tscn",
		"res://scenes/levels/harita_3.tscn"
	]
	GameManager.secili_harita = haritalar[index]

func _isim_al() -> String:
	var isim := $Panel/IsimGirdisi.text.strip_edges()
	return isim if isim != "" else "oyuncu"

func _tek_oyuncu() -> void:
	NetworkManager.is_host = false
	NetworkManager.multiplayer.multiplayer_peer = null
	if GameManager.secili_harita == "":
		GameManager.secili_harita = "res://scenes/levels/harita_1.tscn"
	get_tree().change_scene_to_file(GameManager.secili_harita)

func _sunucu_ac() -> void:
	$DurumEtiketi.text = "sunucu açılıyor..."
	NetworkManager.host_game(_isim_al())

func _baglan() -> void:
	var ip := $Panel/IpGirdisi.text.strip_edges()
	if ip == "":
		$DurumEtiketi.text = "ip gir!"
		return
	$DurumEtiketi.text = "bağlanılıyor: " + ip
	NetworkManager.join_game(ip, _isim_al())

func _oyuncu_listesi_degisti() -> void:
	$DurumEtiketi.text = "oyuncular: " + str(NetworkManager.peers.size())
