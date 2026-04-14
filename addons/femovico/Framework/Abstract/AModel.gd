# AModel is the base class for Models.
# This is used mostly for instanced data and data dynamically created at runtime.
class_name AModel
extends RefCounted

# Enums
enum ERuntimeGroup
{
	NONE,
	COMMON,
	RUN,
	ENCOUNTER
}

# Abstract
func get_runtime_group() -> ERuntimeGroup: return ERuntimeGroup.NONE
