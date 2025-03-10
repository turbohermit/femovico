# ASerializableModelResource is the base class for Models you want to save as a Godot Resource.
# This is useful for pre-made game data like Items/Equipment and Default Settings/Configuration.
# Should be assigned and loaded from Features.
# These ones can be saved via SaveUtility and will be loaded automatically on initialization.
class_name ASaveableModelResource
extends Resource
func get_class_name(): return "ASaveableModelResource"

@export_category("Saveable")
@export var MRID: String

func save():
	var success = SaveUtility.serialize_model(self)
	if not success:
		print(str("Unable to save ", self))

# Returns true if this model exists in save file or cache.
# Otherwise returns false (first initialization)
func load_from_disk() -> bool:
	return SaveUtility.load_saveable(self)

func delete():
	SaveUtility.clear_model(self)

# Virtual functions.
func read_serializables_from_disk(_p_serializables: Array[Variant]):
	pass

func get_serializables_from_instance() -> Array[Variant]:
	return []
