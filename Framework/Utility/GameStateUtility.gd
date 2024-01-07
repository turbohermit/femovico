extends Node

var m_paused: bool
var Paused: bool = false: 
	get: return m_paused

func toggle_pause():
	m_paused = !m_paused
	
	if m_paused:
		Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
