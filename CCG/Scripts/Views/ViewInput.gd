class_name ViewInput
extends AView

# Accessors
var DragPosition: Vector2:
	get: return m_dragPosition

# Private
var m_dragPosition: Vector2

# Signals
signal on_drag_release
signal on_drag_position(p_position: Vector2)

func _input(p_event: InputEvent):
	if p_event is InputEventMouseButton:
		if not p_event.pressed:
			on_drag_release.emit()
	
	if p_event is InputEventMouseMotion:
		m_dragPosition = p_event.position
		on_drag_position.emit(m_dragPosition)
