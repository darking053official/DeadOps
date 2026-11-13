extends Control

signal direction_changed(direction: Vector2)

@export var base_radius: float = 80.0
@export var knob_radius: float = 35.0

var _touch_index: int = -1
var _center: Vector2
var _knob_pos: Vector2
var _direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	_center = size / 2.0
	_knob_pos = _center
	mouse_filter = Control.MOUSE_FILTER_IGNORE

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		var local := get_global_transform_with_canvas().affine_inverse() * event.position
		if event.pressed and _touch_index == -1:
			_touch_index = event.index
			_center = local
			_knob_pos = local
			_update_direction()
			queue_redraw()
		elif not event.pressed and event.index == _touch_index:
			_touch_index = -1
			_knob_pos = _center
			_direction = Vector2.ZERO
			direction_changed.emit(Vector2.ZERO)
			queue_redraw()
	elif event is InputEventScreenDrag and event.index == _touch_index:
		_knob_pos = get_global_transform_with_canvas().affine_inverse() * event.position
		_update_direction()
		queue_redraw()

func _update_direction() -> void:
	var offset := _knob_pos - _center
	var dist := min(offset.length(), base_radius)
	_direction = (offset.normalized() * (dist / base_radius)) if offset.length() > 0 else Vector2.ZERO
	direction_changed.emit(_direction)

func _draw() -> void:
	draw_circle(_center, base_radius, Color(1, 1, 1, 0.15))
	draw_arc(_center, base_radius, 0, TAU, 32, Color(1, 1, 1, 0.4), 2.0)
	draw_circle(_center + _direction * base_radius, knob_radius, Color(1, 1, 1, 0.6))
