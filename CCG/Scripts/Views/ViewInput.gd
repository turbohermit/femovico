class_name ViewInput
extends AView

signal on_drag_release

func _input(p_event: InputEvent):
	if p_event is InputEventMouseButton:
		if not p_event.pressed:
			on_drag_release.emit()
