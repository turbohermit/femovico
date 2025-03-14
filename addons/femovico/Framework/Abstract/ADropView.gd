# This is a view that automatically registers itself as a droppable area in UtilityDragAndDrop.
class_name ADropView
extends AView

@export var HoverNode: Control

# Signals
signal on_hover_start(p_view: ADropView)
signal on_hover_end(p_view: ADropView)

func _ready():
	HoverNode.mouse_entered.connect(mouse_entered_received)
	HoverNode.mouse_exited.connect(mouse_exited_received)

func mouse_entered_received():
	UtilityDragAndDrop.register_view(self)
	on_hovered(true)
	on_hover_start.emit(self)

func mouse_exited_received():
	UtilityDragAndDrop.deregister_view(self)
	on_hovered(false)
	on_hover_end.emit(self)

func on_hovered(p_state: bool):
	pass
