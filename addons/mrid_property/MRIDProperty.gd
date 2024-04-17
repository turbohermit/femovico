extends EditorInspectorPlugin

var MRIDGenerator = preload("res://addons/mrid_property/MRIDGenerator.gd")
const MRID_NAME = "MRID"

func _can_handle(object):
	return object is AModelResource

func _parse_property(object, type, name, hint_type, hint_string, usage_flags, wide):
	if type == TYPE_STRING and name == MRID_NAME:
		add_property_editor(name, MRIDGenerator.new(object.MRID))
		return true
	else:
		return false
