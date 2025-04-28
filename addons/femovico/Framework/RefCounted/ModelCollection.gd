# ModelCollection tracks instances of AModels of specific types.
# A single, shared ModelCollection is instantiated and spread across features.
class_name ModelCollection
extends RefCounted

# "Private"
var m_typeToInstance: Dictionary

func _init():
	print("ModelCollection initialized.")

# Gets a model of type, and if it doesn't exist yet, initializes it.
func fetch(p_modelType: GDScript):
	if not m_typeToInstance.has(p_modelType):
		create_model(p_modelType)
	return m_typeToInstance[p_modelType]

func create_model(p_modelType: GDScript):
	if m_typeToInstance.has(p_modelType):
		print(str("Initiazing model of type that already exists: ", p_modelType.get_global_name(), ". Overwriting."))
	m_typeToInstance[p_modelType] = p_modelType.new()
