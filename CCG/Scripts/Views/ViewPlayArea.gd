class_name ViewPlayArea
extends ADropView

@export_category("Nodes")
@export var PlayerAreasContainer: Control
@export var PlayerRow: Array[Control]

func on_initialized():
	pass

func update(_p_model: ModelPlayArea):
	pass

func get_area(p_playerIndex: int) -> Node:
	return PlayerRow[p_playerIndex]

func on_hovered(_p_state: bool):
	pass
