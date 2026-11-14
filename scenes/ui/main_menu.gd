extends Control

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	# Butonları güvenli bir şekilde bağla
	var tek_btn = get_node_or_null("Panel/TekButonu")
	var sunucu_btn = get_node_or_null("Panel/SunucuButonu")
	var baglan_btn = get_node_or_null("Panel/BaglanButonu")
	
	if tek_btn:
		tek_btn.pressed.connect(_tek_oyuncu)
	if sunucu_btn:
		sunucu_btn.pressed.connect(_sunucu_ac)
	if baglan_btn:
		baglan_btn.pressed.connect(_baglan)

	# Harita seçimini doldur
	var secim = get_node_or_null("Panel/HaritaSecimi")
	if secim:
		secim.clear()
		secim.add_item("şehir", 0)
		secim.add_item("depo", 1)
		secim.add_item("çöl", 2)
		secim.select(0)
		secim.item_selected.connect(_harita_secildi)
		_harita_secildi(0)

	NetworkManager.player_list_changed.connect(_oyuncu_listesi_degisti)

func _harita_secildi(index: int) -> void:
	var haritalar := [
		"res://scenes/levels/harita_1.tscn",
		"res://scenes/levels/harita_2.tscn",
		"res://scenes/levels/harita_3.tscn"
	]
	GameManager.secili_harita = haritalar[index]

func _isim_al() -> String:
	var isim_girdisi = get_node_or_null("Panel/IsimGirdisi")
	if isim_girdisi:
		var isim = isim_girdisi.text.strip_edges()
		return isim if isim != "" else "oyuncu"
	return "oyuncu"

func _tek_oyuncu() -> void:
	NetworkManager.is_host = false
	NetworkManager.multiplayer.multiplayer_peer = null
	if GameManager.secili_harita == "":
		GameManager.secili_harita = "res://scenes/levels/harita_1.tscn"
	get_tree().change_scene_to_file(GameManager.secili_harita)

func _sunucu_ac() -> void:
	var durum = get_node_or_null("DurumEtiketi")
	if durum: durum.text = "sunucu açılıyor..."
	NetworkManager.host_game(_isim_al())

func _baglan() -> void:
	var ip_girdisi = get_node_or_null("Panel/IpGirdisi")
	var durum = get_node_or_null("DurumEtiketi")
	if not ip_girdisi or not durum: return
	
	var ip = ip_girdisi.text.strip_edges()
	if ip == "":
		durum.text = "ip gir!"
		return
	durum.text = "bağlanılıyor: " + ip
	NetworkManager.join_game(ip, _isim_al())

func _oyuncu_listesi_degisti() -> void:
	var durum = get_node_or_null("DurumEtiketi")
	if durum:
		durum.text = "oyuncular: " + str(NetworkManager.peers.size())
