# Global utility class that handles save managing
extends Node

# Constants
const user_path: String = "user://save.json"

# Instanced
var m_saveFile: FileAccess
# Key: Class Key, Value: Dictionary (Key: MRID, Value: Array[Serializables])
var m_cachedModels: Dictionary

# Public Functions
func model_exists_in_cache(p_class: GDScript, p_key: String) -> bool:
	var classKey = get_class_key(p_class)
	download_data_from_disk()
	return m_cachedModels.has(classKey) and m_cachedModels[classKey].has(p_key)

# Adds Model to cache and then writes cache to save file.
func serialize_model(p_saveable: ASaveableModelResource) -> bool:
	download_data_from_disk()
	
	var classKey: String = get_class_key(p_saveable.get_script())
	var modelKey: String = p_saveable.MRID
	
	# Initialize dictionary for that class if it's not already.
	if not m_cachedModels.has(classKey):
		m_cachedModels[classKey] = {}
	
	m_cachedModels[classKey][modelKey] = p_saveable.get_serializables_from_instance()
	write_cache_to_save_file()
	return true

# Returns Model from cache if it has key, otherwise returns a new one.
func load_saveable(p_saveable: ASaveableModelResource) -> bool:
	download_data_from_disk()
	
	var classKey = get_class_key(p_saveable.get_script())
	var modelKey = p_saveable.MRID
	if m_cachedModels.has(classKey) and m_cachedModels[classKey].has(modelKey):
		p_saveable.read_serializables_from_disk(m_cachedModels[classKey][modelKey])
		return true
	
	# Initialize dictionary for that class if it's not already.
	if not m_cachedModels.has(classKey):
		m_cachedModels[classKey] = {}
	
	return false

# "Private" functions
# Converts cache to JSON parsable data and then writes it to save file.
func write_cache_to_save_file():
	if m_saveFile == null or not m_saveFile.is_open():
		m_saveFile = FileAccess.open(user_path, FileAccess.WRITE)
	
	# TODO, REMOVE ALL THIS? JUST SAVE THE CACHE
	var parsableData: Dictionary = {}
	for classKey in m_cachedModels.keys():
		parsableData[classKey] = {}
		
		# For each cached model, 
		for modelKey in m_cachedModels[classKey].keys():
			parsableData[classKey][modelKey] = m_cachedModels[classKey][modelKey]
	
	var contents: String = JSON.stringify(parsableData)
	m_saveFile.store_line(contents)
	m_saveFile.close()
	return true

# Reads save data from JSON file and instantiates Models from it into cache.
func download_data_from_disk() -> bool:
	if m_cachedModels != null && m_cachedModels.size() != 0:
		return true

	if not FileAccess.file_exists(user_path):
		print(str("No save file found at ", user_path))
		return false
	
	m_saveFile = FileAccess.open(user_path, FileAccess.READ)
	var contents = m_saveFile.get_line()
	var json = JSON.new()
	
	# Check if there is any error while parsing the JSON string, skip in case of failure
	var error = json.parse(contents)
	if error != OK:
		var errorMessage = json.get_error_message()
		print(str("JSON Parse Error Code: ", error, " Message: ", errorMessage))
		m_saveFile.close()
		return false
	
	#Dictionary Key: Class Key, Value: Dictionary (Key: Model Key, Value: Array[Variants])
	# TODO: Just cache entire json.
	m_cachedModels = {}
	var parsedData = json.get_data()
	
	for classKey in parsedData:
		m_cachedModels[classKey] = {}
		
		for modelKey in parsedData[classKey]:
			m_cachedModels[classKey][modelKey] = parsedData[classKey][modelKey]
	
	m_saveFile.close()
	return true

func clear_save():
	if m_saveFile != null and m_saveFile.is_open():
		m_saveFile.close()
	
	m_cachedModels.clear()
	m_saveFile = FileAccess.open(user_path, FileAccess.WRITE)
	m_saveFile.close()

func clear_model(p_model: ASaveableModelResource):
	download_data_from_disk()
	
	var classKey = get_class_key(p_model.get_script())
	var modelKey = p_model.MRID
	
	if not m_cachedModels.has(classKey) or not m_cachedModels[classKey].has(modelKey):
		print(str("Model to delete not found in cache ", modelKey))
		return
	
	m_cachedModels[classKey].erase(modelKey)
	write_cache_to_save_file()

# Passing a class like this basically passes a shorthand for the Class file's path.
# So this just strips the rest and uses only the class name.
# Renaming a class can potentially break save files. Not very beautiful.
func get_class_key(p_class: GDScript) -> String:
	return p_class.get_path()
