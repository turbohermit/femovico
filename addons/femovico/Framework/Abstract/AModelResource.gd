# AModelResource is the base class for Models you want to save  as a Godot Resource.
# This is useful for pre-made game data like Items/Equipment and Default Settings/Configuration.
# Should be assigned and loaded from Features.
class_name AModelResource
extends Resource

@export_category("Model Resource")
@export var MRID: String

# "Abstract" functions.
func instantiate():
	var instance = self.duplicate()
	return instance
