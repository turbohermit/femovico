class_name ViewPlayArea
extends AView

@export_category("Nodes")
@export var PlayerAreasContainer: Control
@export var PlayerRow: Array[Control]

func update(p_model: ModelPlayArea):
	pass

func get_area(p_playerIndex: int) -> Node:
	return PlayerRow[p_playerIndex]
