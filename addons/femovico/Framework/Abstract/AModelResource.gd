# AModelResource is the base class for Models you want to save  as a Godot Resource.
# This is useful for pre-made game data like Items/Equipment and Default Settings/Configuration.
# Should be assigned and loaded from Features.
class_name AModelResource
extends Resource

# Accessors
var SourcePath: StringName:
	get: return m_sourcePath
var InstanceUUID: StringName:
	get: return m_instanceID
var IsLoadedFromDisk:
	get: return m_loadedFromDisk

# Private
var m_sourcePath: StringName
var m_instanceID: StringName
var m_loadedFromDisk: bool

# Virtual implementations.
func _to_string() -> String:
	return m_instanceID

# Private functions.
func instantiate():
	var instance = self.duplicate(true)
	instance.generate_id(self)
	instance.on_instantiate()
	return instance

# Public functions.
func SameSourceAsset(p_target: AModelResource) -> bool:
	return p_target.SourcePath == m_sourcePath

func SameSourcePath(p_path: StringName):
	return p_path == m_sourcePath

func ForceUUID(p_id: StringName, p_sourcePath: String):
	m_instanceID = p_id
	m_sourcePath = p_sourcePath

# Private functions.
func generate_id(p_original: AModelResource):
	m_instanceID = UtilID.generate_uuid()
	if p_original == null:
		return
	
	if p_original != null:
		if p_original.m_sourcePath.is_empty():
			m_sourcePath = p_original.resource_path
		else:
			m_sourcePath = p_original.SourcePath

func save():
	if m_instanceID.is_empty():
		generate_id(null)
	
	UtilSave.save_resource_instance(self)

func load_from_disk(p_serializables: Array[Variant]):
	m_loadedFromDisk = true
	read_serializables_from_disk(p_serializables)

func delete():
	UtilSave.clear_model(self)

# Virtual functions.
func on_instantiate():
	pass

func read_serializables_from_disk(_p_serializables: Array[Variant]):
	pass

func get_serializables_from_instance() -> Array[Variant]:
	return []
