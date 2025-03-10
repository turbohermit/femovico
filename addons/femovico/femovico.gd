@tool
extends EditorPlugin

const AUTOLOAD_SAVE = "SaveUtility"
const AUTOLOAD_ID = "IDUtility"
const AUTOLOAD_GAMESTATE = "GameStateUtility"
const AUTOLOAD_INPUT = "InputUtility"

func _enter_tree():
	pass

func _exit_tree():
	pass

func _enable_plugin():
	add_autoload_singleton(AUTOLOAD_SAVE, "res://addons/femovico/Framework/Utility/SaveUtility.gd")
	add_autoload_singleton(AUTOLOAD_ID, "res://addons/femovico/Framework/Utility/IDUtility.gd")
	add_autoload_singleton(AUTOLOAD_GAMESTATE, "res://addons/femovico/Framework/Utility/GameStateUtility.gd")
	add_autoload_singleton(AUTOLOAD_INPUT, "res://addons/femovico/Framework/Utility/InputUtility.gd")

func _disable_plugin():
	remove_autoload_singleton(AUTOLOAD_SAVE)
	remove_autoload_singleton(AUTOLOAD_ID)
	remove_autoload_singleton(AUTOLOAD_GAMESTATE)
	remove_autoload_singleton(AUTOLOAD_INPUT)
