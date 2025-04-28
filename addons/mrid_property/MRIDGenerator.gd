class_name MRIDGenerator
extends EditorProperty

var m_propertyControl = Label.new()
var m_currentValue: String = ""

func _init(p_objectMRIDValue: String):
	m_currentValue = p_objectMRIDValue
	m_propertyControl.text = p_objectMRIDValue
	add_child(m_propertyControl)

func _process(delta):
	if m_currentValue.is_empty():
		m_currentValue = UtilID.generate()
		emit_changed(get_edited_property(), m_currentValue)
		m_propertyControl.text = m_currentValue
