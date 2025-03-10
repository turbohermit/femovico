# ASerializableModel can be used for easy referencing of runtime data saved on disk.
# Useful for game saving.
class_name ASerializableModel
extends AModel
func get_class_name(): return "ASerializableModel"

func save():
	var success = SaveUtility.serialize_model(self)
	if not success:
		print(str("Unable to save ", self))

func get_serializables() -> Array[Variant]:
	return []

func get_serialization_key() -> String:
	return "NotImplemented"

func download_serializables(_p_serializables: Array[Variant]):
	pass

func delete():
	SaveUtility.clear_model(self)
