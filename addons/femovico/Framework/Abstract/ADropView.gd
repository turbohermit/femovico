# This is a view that automatically registers itself as a droppable area in UtilityDragAndDrop.
class_name ADropView
extends AView

# Signals
signal on_hover_start(p_view: ADropView)
signal on_hover_end(p_view: ADropView)

func mouse_entered_received():
	on_hovered(true)
	on_hover_start.emit(self)

func mouse_exited_received():
	on_hovered(false)
	on_hover_end.emit(self)

func on_hovered(p_state: bool):
	pass
