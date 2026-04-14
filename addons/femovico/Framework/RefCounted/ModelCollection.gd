# ModelCollection tracks instances of AModels of specific types.
# A single, shared ModelCollection is instantiated and spread across features.
class_name ModelCollection
extends RefCounted

# Private
var m_typeToInstance: Dictionary

func _init():
	print("ModelCollection initialized.")

# Check the cache if the type exists and if not tries to load it.
# If there is no loadable version on user's disk, create one.
func fetch(p_modelType: GDScript):
	if m_typeToInstance.has(p_modelType):
		return m_typeToInstance[p_modelType]
	
	var instance = create_model(p_modelType)
	if instance is ASaveableModel && UtilSave.has_model(instance):
		instance.load_from_disk()
	
	return instance

func has_model(p_modelType: GDScript) -> bool:
	return m_typeToInstance.has(p_modelType)

func create_model(p_modelType: GDScript):
	if m_typeToInstance.has(p_modelType):
		print(str("Initiazing Model of type that already exists: ", p_modelType.get_global_name(), ". Overwriting."))
	m_typeToInstance[p_modelType] = p_modelType.new()
	return m_typeToInstance[p_modelType]

func kickstart_model_resource(p_resource: AModelResource):
	var modelType: GDScript = p_resource.get_script()
	var model = p_resource.instantiate()
	m_typeToInstance[modelType] = model
	return model

func reset_group(p_group: AModel.ERuntimeGroup):
	var keys: Array = m_typeToInstance.keys()
	for i in range(keys.size() - 1, -1, -1):
		var instance = m_typeToInstance[keys[i]]
		if not instance is AModel:
			continue
		
		if not instance.get_runtime_group() == p_group:
			continue
		
		m_typeToInstance.erase(keys[i])
