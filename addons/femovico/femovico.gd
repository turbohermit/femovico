@tool
extends EditorPlugin

const AUTOLOAD_SAVE = "UtilSave"
const AUTOLOAD_ID = "UtilID"
const AUTOLOAD_GAMESTATE = "UtilGameState"
const AUTOLOAD_INPUT = "UtilInput"

func _enter_tree():
	pass

func _exit_tree():
	pass

func _enable_plugin():
	add_autoload_singleton(AUTOLOAD_SAVE, "res://addons/femovico/Framework/Utility/UtilSave.gd")
	add_autoload_singleton(AUTOLOAD_ID, "res://addons/femovico/Framework/Utility/UtilID.gd")
	add_autoload_singleton(AUTOLOAD_GAMESTATE, "res://addons/femovico/Framework/Utility/UtilGameState.gd")
	add_autoload_singleton(AUTOLOAD_INPUT, "res://addons/femovico/Framework/Utility/UtilInput.gd")

func _disable_plugin():
	remove_autoload_singleton(AUTOLOAD_SAVE)
	remove_autoload_singleton(AUTOLOAD_ID)
	remove_autoload_singleton(AUTOLOAD_GAMESTATE)
	remove_autoload_singleton(AUTOLOAD_INPUT)
