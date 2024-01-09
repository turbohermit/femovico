class_name CreatureModelResource
extends AModelResource
func get_class_name(): return "CreatureModelResource"

@export_category("Creature Base Stats")
@export var Health: int = 10
@export var Speed: float = 0.2
@export var Scale: float = 1.0
