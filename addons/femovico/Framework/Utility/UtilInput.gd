extends Node

# Enum
enum EInputDevice
{
	UNSPECIFIED = 0,
	UNRECOGNIZED = 1,
	KEYBOARD = 2,
	MOUSE = 3,
	JOYPAD = 4
}

enum EInputAction
{
	UNSPECIFIED = 0,
	INTERACT = 1,
	INSPECT = 2,
	CANCEL = 3,
	RUN = 4,
	INVENTORY_MENU = 5,
	CLUES_MENU = 6,
	PAUSE = 7,
	MOVE_UP = 8,
	MOVE_DOWN = 9,
	MOVE_LEFT = 10,
	MOVE_RIGHT = 11
}

# Private
var m_deviceType: EInputDevice = EInputDevice.KEYBOARD
var m_deviceID: String
var m_configInputMap: ConfigInputMap = load("res://Assets/ModelResources/Configs/config_input_map.tres")

# Mapped to JoyButton enum.
var m_xboxMapping: Array[String] = ["A", "B", "X", "Y", "Back", "Home", "Start", "LS", "RS", "LB", "RB", "D-Up", "D-Down", "D-Left", "D-Right"]
var m_psMapping: Array[String] = ["x", "○", "□", "△", "Select", "Home", "Options", "LS", "RS", "LB", "RB", "Up", "Down", "Left", "Right"]
var m_nintendoMapping: Array[String] = ["B", "A", "Y", "X", "-", "Home", "+", "LS", "RS", "LB", "RB", "Up", "Down", "Left", "Right"]
var m_mouseMapping: Array[String] = ["CONTROL_MOUSE_BUTTON_LEFT", "CONTROL_MOUSE_BUTTON_RIGHT", "CONTROL_MOUSE_BUTTON_MIDDLE"]

# Signals
signal on_device_changed

func check_device(p_event: InputEvent):
	var newDevice: EInputDevice = m_deviceType
	if p_event is InputEventKey:
		newDevice = EInputDevice.KEYBOARD
	elif p_event is InputEventMouseButton:
		newDevice = EInputDevice.MOUSE
	elif p_event is InputEventJoypadButton:
		newDevice = EInputDevice.JOYPAD
	elif p_event is InputEventJoypadMotion && p_event.axis_value > 0.2:
		newDevice = EInputDevice.JOYPAD
	
	if newDevice == m_deviceType:
		return
	
	m_deviceType = newDevice
	if newDevice == EInputDevice.JOYPAD:
		m_deviceID = Input.get_joy_guid(p_event.device)
	
	on_device_changed.emit()

func get_action_text(p_action: EInputAction, p_device: EInputDevice = EInputDevice.UNSPECIFIED) -> String:
	if p_action == EInputAction.UNSPECIFIED:
		return ""
	
	var device = m_deviceType
	if p_device != EInputDevice.UNSPECIFIED:
		device = p_device
	
	var actionInputs: Array = m_configInputMap.get_action_events(p_action)
	
	for input: InputEvent in actionInputs:
		if input is InputEventKey && device == EInputDevice.KEYBOARD:
			var eventKey: InputEventKey = input as InputEventKey
			var keycode = eventKey.get_physical_keycode_with_modifiers()
			return OS.get_keycode_string(keycode)
		elif input is InputEventMouseButton && device == EInputDevice.MOUSE:
			return get_mouse_button_name(input.button_index)
		elif input is InputEventJoypadButton && device == EInputDevice.JOYPAD:
			return get_joy_button_name(input.button_index)
	
	return ""

func get_action_text_all_devices(p_action: EInputAction) -> String:
	var actionInputs: Array = m_configInputMap.get_action_events(p_action)
	var allActions: String = ""
	
	for i in actionInputs.size():
		var actionText: String
		var input: InputEvent = actionInputs[i]
		
		if input is InputEventKey:
			var eventKey: InputEventKey = input as InputEventKey
			var keycode = eventKey.get_physical_keycode_with_modifiers()
			actionText = "⌨️ " + OS.get_keycode_string(keycode)
		elif input is InputEventMouseButton:
			actionText = "🖱️ " + get_mouse_button_name(input.button_index)
		elif input is InputEventJoypadButton:
			actionText = "🎮 " + get_joy_button_name(input.button_index)
		elif input is InputEventJoypadMotion:
			actionText = "🎮 " + get_joy_stick_name(input.axis)
		
		allActions += actionText
		if i + 1 < actionInputs.size():
			allActions += " "
	
	return allActions

func get_mouse_button_name(p_button: MouseButton) -> String:
	var index = p_button - 1
	if index >= 0 && p_button < m_mouseMapping.size():
		return tr(m_mouseMapping[index])
	
	return "?"

func get_joy_button_name(p_button: JoyButton) -> String:
	return m_xboxMapping[p_button]

func get_joy_stick_name(p_axis: JoyAxis) -> String:
	match p_axis:
		0:
			return "LS X"
		1:
			return "LS Y"
		2:
			return "RS X"
		3:
			return "RS Y"
		4:
			return "LT"
		5:
			return "RT"
	
	return "?"
