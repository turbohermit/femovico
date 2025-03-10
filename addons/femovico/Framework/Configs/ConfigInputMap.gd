class_name ConfigInputMap
extends ASaveableModelResource
func get_class_name(): return "ConfigInputMap"

@export_category("View Scenes")
@export var InputSettingsViewScene: PackedScene
@export var InputSettingsPromptViewScene: PackedScene

# Const
const SAVE_PATH: String = "user://input/"

# Private
var m_pathMap: Dictionary
var m_enumToString: Dictionary

func initialize():
	for i in InputUtility.EInputAction.size():
		var actionKey: StringName = InputUtility.EInputAction.keys()[i].to_lower()
		m_enumToString[i] = actionKey
	
	if load_from_disk():
		return
	
	save()

func override_action(p_action: InputUtility.EInputAction, p_event: InputEvent):
	var actionKey: StringName = m_enumToString[p_action]
	override_action_with_key(actionKey, p_event)
	save()

func override_action_with_key(p_action: StringName, p_event: InputEvent):
	erase_events_of_type(p_action, p_event.get_class())
	InputMap.action_add_event(p_action, p_event)

# Erases input events from action using the same class (InputEventMouse, InputEventJoypadButton, etc.)
func erase_events_of_type(p_action, p_type):
	var events: Array[InputEvent] = InputMap.action_get_events(p_action)
	for event in events:
		if event.get_class() == p_type:
			InputMap.action_erase_event(p_action, event)

func reset_input_map():
	InputMap.load_from_project_settings()
	save()

func get_action_events(p_action: InputUtility.EInputAction) -> Array:
	if p_action == InputUtility.EInputAction.UNSPECIFIED:
		return []
	
	var actionKey: StringName = m_enumToString[p_action]
	return InputMap.action_get_events(actionKey)

func get_action_from_input(p_event: InputEvent) -> InputUtility.EInputAction:
	var keys: Array = InputUtility.EInputAction.keys()
	for i in keys.size():
		# Skip unspecified input
		if i == 0:
			continue
		
		var actionKey: StringName = m_enumToString[i]
		if p_event.is_action_pressed(actionKey):
			return i as InputUtility.EInputAction
	
	return InputUtility.EInputAction.UNSPECIFIED

# Virtual functions.
func read_serializables_from_disk(p_serializables: Array[Variant]):
	m_pathMap = p_serializables[0]
	
	var actions: Array[StringName] = InputMap.get_actions()
	for actionKey in actions:
		InputMap.action_erase_events(actionKey)
		
		for path in m_pathMap[actionKey]:
			var event: InputEvent = ResourceLoader.load(path, "InputEvent")
			if event == null:
				push_error(str("Badly assigned input map: ", path))
				continue
			
			InputMap.action_add_event(actionKey, event)

func get_serializables_from_instance() -> Array[Variant]:
	m_pathMap = {}
	
	if not DirAccess.dir_exists_absolute(SAVE_PATH):
		DirAccess.make_dir_absolute(SAVE_PATH)
	
	var actions: Array[StringName] = InputMap.get_actions()
	for actionKey in actions:
		var events: Array[InputEvent] = InputMap.action_get_events(actionKey)
		var paths: Array[String] = []
		
		for i in events.size():
			var path: String = str(SAVE_PATH, actionKey, i, ".tres")
			var error = ResourceSaver.save(events[i], path)
			if error == OK:
				paths.append(path)
		
		m_pathMap[actionKey] = paths
	
	return [m_pathMap]
