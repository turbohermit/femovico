# Global utility class that handles save managing
extends Node

# Accessors
var Profile: int:
	get: return m_currentProfile

# Constants
const MODELS_SECTION: String = "unique_models"
const VALIDATION_SECTION: String = "validation"
const PROPERTY_USAGE_KEY: String = "usage"
const PROPERTY_NAME_KEY: String = "name"
const CLASS_NAME_KEY: String = "class_name"
const VERSION_KEY: String = "version"

# Private
var m_currentProfile: int = 0
var m_saveFile: ConfigFile = null
var m_dirty: bool = false

# Cache
var m_resourceInstances: Dictionary
var m_idToClassPath: Dictionary

# Signals
signal on_save_complete

# Virtual implementations.
func _process(p_delta: float) -> void:
	if not m_dirty:
		return
	
	await get_tree().process_frame
	write_save_file_to_disk()

# Private functions.
func read_save_from_disk() -> bool:
	if m_saveFile != null:
		return true
	
	m_saveFile = ConfigFile.new()
	var savePath: String = get_save_path()
	var error: Error = m_saveFile.load(savePath)
	
	# No save file found, 
	if error == ERR_FILE_NOT_FOUND:
		write_save_file_to_disk()
		return false
	
	if error == OK:
		if m_saveFile.has_section(MODELS_SECTION):
			create_id_to_class_ledger()
		return true
	
	push_error(error_string(error))
	return false

func write_save_file_to_disk():
	var version: String = ProjectSettings.get_setting("application/config/version")
	m_saveFile.set_value(VALIDATION_SECTION, VERSION_KEY, version)
	
	var savePath: String = get_save_path()
	var error: Error = m_saveFile.save(savePath)
	if error != OK:
		push_error(error_string(error))
	
	create_id_to_class_ledger()
	m_dirty = false
	on_save_complete.emit()

# Save a ASaveableModel to the config and mark it dirty for saving.
# ASaveableModels are unique so their key is the path to the class.
func save_model(p_saveableModel: ASaveableModel):
	read_save_from_disk()
	
	var serializables: Array[Variant] = p_saveableModel.get_serializables_from_instance()
	var path: String = get_class_path(p_saveableModel)
	m_saveFile.set_value(MODELS_SECTION, path, serializables)
	m_dirty = true

# Save an AModelResource instance to the config and mark it dirty for saving.
# The section of the config is the class's path, and its InstanceUUID is the key for this particular instance.
func save_resource_instance(p_modelResource: AModelResource):
	read_save_from_disk()
	
	var serializables: Array[Variant] = p_modelResource.get_serializables_from_instance()
	# Add path of original asset to the end of serializeables automatically.
	serializables.append(p_modelResource.SourcePath)
	
	var path: String = get_class_path(p_modelResource)
	m_saveFile.set_value(path, p_modelResource.InstanceUUID, serializables)
	m_dirty = true

# Read saveable model from disk and assign serializeables directly to it.
func load_model(p_saveableModel: ASaveableModel):
	read_save_from_disk()
	
	var path: String = get_class_path(p_saveableModel)
	var serializeables: Array[Variant] = m_saveFile.get_value(MODELS_SECTION, path)
	p_saveableModel.read_serializables_from_disk(serializeables)

# See if a resource instance with supplies InstanceUUID exists in the cache.
# If not, create an instance, save it to the cache and return it.
# This allows isntance creation on demand.
func load_resource_reference(p_id: String) -> AModelResource:
	if m_resourceInstances.has(p_id):
		return m_resourceInstances[p_id]
	
	var instance = create_resource_instance(p_id)
	return instance

# Iterate through an array of InstanceUUIDs and try to load each individual resource instance.
func load_resource_references(p_ids: PackedStringArray) -> Array:
	var resources: Array = []
	for i in p_ids.size():
		var resource = load_resource_reference(p_ids[i])
		if resource == null:
			continue
		
		resources.append(resource)
	
	return resources

# Create an instance for the supplies InstanceUUID, by referring to the class ledger for its class's path.
# Then assigns serializeables to it.
func create_resource_instance(p_id: StringName) -> AModelResource:
	var section: String = m_idToClassPath[p_id]
	var classType: GDScript = load(section)
	var serializables: Array[Variant] = m_saveFile.get_value(section, p_id)
	# Read the last entry of serializeables to be the original asset path.
	var sourcePath: StringName = serializables[serializables.size() - 1]
	
	# Create instance and apply all serializeables.
	var instance = classType.new()
	if not sourcePath.is_empty():
		var sourceAsset = load(sourcePath)
		instance = sourceAsset.duplicate(true)
	
	# Then apply all serialized data to the instance to overwrite default values if neccesary.
	m_resourceInstances[instance.InstanceUUID] = instance
	instance.ForceUUID(p_id, sourcePath)
	instance.load_from_disk(serializables)
	
	return instance

# See if the save file contains a key for the supplies ASaveableModel.
func has_model(p_saveableModel: ASaveableModel) -> bool:
	read_save_from_disk()
	var path: String = get_class_path(p_saveableModel)
	return m_saveFile.has_section_key(MODELS_SECTION, path)

# Create a dictionary that links an InstanceUUID to its parent's class path.
# This makes it easy to create an instance for a specific InstanceUUID, without needing more information.
func create_id_to_class_ledger():
	read_save_from_disk()
	
	var sections: PackedStringArray = m_saveFile.get_sections()
	for section in sections:
		if section == MODELS_SECTION or section == VALIDATION_SECTION:
			continue
		
		# Read class path from section head.
		var classType: GDScript = load(section)
		if classType == null:
			continue
		
		# Get instance ID for each instance.
		var keys: PackedStringArray = m_saveFile.get_section_keys(section)
		for key in keys:
			m_idToClassPath[key] = section

# Helper functions.
func get_class_path(p_instance) -> String:
	return p_instance.get_script().resource_path

# Save every AModelResource in the supplied array and returns their InstanceUUIDs for easy serialization.
func save_resource_instance_references(p_resources: Array) -> PackedStringArray:
	var ids: PackedStringArray = []
	for i in p_resources.size():
		if not p_resources[i] is AModelResource:
			push_error("Trying to serialize InstanceUUID on class that does not derive from AModelResource.")
			continue
		
		p_resources[i].save()
		ids.append(p_resources[i].InstanceUUID)
	return ids

# Save the supplied AModelResource and returns its InstanceUUIDs for easy serialization.
func save_resource_instance_reference(p_resource: AModelResource) -> StringName:
	p_resource.save()
	return p_resource.InstanceUUID
	
# Converts each @export variable on the supplied object into an array of serializeables.
func get_serializables_from_properties(p_object: Object) -> Array[Variant]:
	var serializables: Array[Variant] = []
	var properties: Array[Dictionary] = p_object.get_property_list()
	for i in properties.size():
		# Filter properties so that we end up with just @export and @export_storage properties.
		var usage: int = properties[i][PROPERTY_USAGE_KEY]
		if not (usage & PROPERTY_USAGE_SCRIPT_VARIABLE) || not (usage & PROPERTY_USAGE_STORAGE):
			continue
		
		var key: StringName = StringName(properties[i][PROPERTY_NAME_KEY])
		var propertyValue = p_object.get(key)
		if propertyValue != null && propertyValue is AModelResource:
			propertyValue = UtilSave.save_resource_instance_reference(propertyValue)
		
		serializables.append(propertyValue)
	
	return serializables

# Iterates over each @export variable on the object and tries to assign each serializeable loaded from disk to it.
# Used primarily for AEffects.
func set_serializables_on_properties(p_modelResource: AModelResource, p_serializables: Array[Variant]):
	var properties: Array[Dictionary] = p_modelResource.get_property_list()
	var serializableIndex: int = 0
	
	for i in properties.size():
		# Filter properties so that we end up with just @export and @export_storage properties.
		var usage: int = properties[i][PROPERTY_USAGE_KEY]
		if not (usage & PROPERTY_USAGE_SCRIPT_VARIABLE) || not (usage & PROPERTY_USAGE_STORAGE):
			continue
		
		var key: StringName = StringName(properties[i][PROPERTY_NAME_KEY])
		if p_serializables[serializableIndex] is StringName:
			p_serializables[serializableIndex] = UtilSave.load_resource_reference(p_serializables[serializableIndex])
		
		p_modelResource.set(key, p_serializables[serializableIndex])
		serializableIndex += 1

func delete_run():
	clear_cache()
	
	var hasFile: bool = read_save_from_disk()
	if hasFile:
		m_saveFile.clear()
		write_save_file_to_disk()

func delete_model(p_classType: GDScript):
	var hasFile: bool = read_save_from_disk()
	if hasFile:
		m_saveFile.erase_section_key(MODELS_SECTION, p_classType.resource_path)

func clear_cache():
	m_saveFile = null
	m_resourceInstances.clear()
	m_idToClassPath.clear()
	create_id_to_class_ledger()

func get_save_path() -> String:
	return str("user://profile_", m_currentProfile, "_run_save.cfg")

func has_run_save() -> bool:
	var hasFile: bool = read_save_from_disk()
	
	# If file exists: see if it has any serialized models.
	# Otherwise it could be an empty file, which does not count as a save.
	if hasFile:
		return m_saveFile.has_section(MODELS_SECTION)
	
	return false

func is_save_valid() -> bool:
	if not has_run_save():
		return false
	
	# The save is always valid if this version is backwards compatible.
	var currentVersion: String = ProjectSettings.get_setting("application/config/version")
	if not ProjectSettings.get_setting("bibidi/versioning/invalidate_previous_version_run_saves"):
		return true
	
	# If there is no version found at all
	if not m_saveFile.has_section_key(VALIDATION_SECTION, VERSION_KEY):
		delete_run()
		return false
	
	# If there's a version discrepency.
	var savedVersion: String = m_saveFile.get_value(VALIDATION_SECTION, VERSION_KEY)
	if savedVersion != currentVersion:
		delete_run()
		return false
	
	return true
