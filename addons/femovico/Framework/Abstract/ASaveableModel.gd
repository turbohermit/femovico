# ASaveableModel is the base class for Models you want users to be able to save to disk.
# These ones can be saved via SaveUtility and will be loaded automatically on initialization.
class_name ASaveableModel
extends AModel

# Accessors
var LoadedFromSaveFile: bool:
	get: return m_wasLoadedFromSave

# private
var m_wasLoadedFromSave: bool

func save():
	UtilSave.save_model(self)

func load_from_disk():
	m_wasLoadedFromSave = true
	UtilSave.load_model(self)

func delete():
	UtilSave.clear_model(self)

# Virtual functions.
func read_serializables_from_disk(_p_serializables: Array[Variant]):
	pass

func get_serializables_from_instance() -> Array[Variant]:
	return []
