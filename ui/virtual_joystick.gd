extends Control

signal yon_degisti(yon: Vector2)

@export var taban_yaricap: float = 80.0
@export var topuz_yaricap: float = 35.0

var _dokunma_indeksi: int = -1
var _merkez: Vector2
var _topuz_konum: Vector2
var _yon: Vector2 = Vector2.ZERO

func _ready() -> void:
	_merkez = size / 2.0
	_topuz_konum = _merkez
	mouse_filter = Control.MOUSE_FILTER_STOP

func _gui_input(olay: InputEvent) -> void:
	if olay is InputEventScreenTouch:
		if olay.pressed and _dokunma_indeksi == -1:
			_dokunma_indeksi = olay.index
			_merkez = olay.position
			_topuz_konum = olay.position
			_yonu_guncelle()
			queue_redraw()
		elif not olay.pressed and olay.index == _dokunma_indeksi:
			_dokunma_indeksi = -1
			_topuz_konum = _merkez
			_yon = Vector2.ZERO
			yon_degisti.emit(Vector2.ZERO)
			queue_redraw()
	elif olay is InputEventScreenDrag and olay.index == _dokunma_indeksi:
		_topuz_konum = olay.position
		_yonu_guncelle()
		queue_redraw()

func _yonu_guncelle() -> void:
	var fark := _topuz_konum - _merkez
	var mesafe := min(fark.length(), taban_yaricap)
	_yon = (fark.normalized() * (mesafe / taban_yaricap)) if fark.length() > 0 else Vector2.ZERO
	yon_degisti.emit(_yon)

func _draw() -> void:
	draw_circle(_merkez, taban_yaricap, Color(1, 1, 1, 0.15))
	draw_arc(_merkez, taban_yaricap, 0, TAU, 32, Color(1, 1, 1, 0.4), 2.0)
	draw_circle(_merkez + _yon * taban_yaricap, topuz_yaricap, Color(1, 1, 1, 0.6))
