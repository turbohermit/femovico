# Simple utility class to pause the game.
# You can implement your own in FeatureInitializer or wherever you call update_tick() on your Features.
extends Node

var m_paused: bool

var Paused: bool = false: 
	get: return m_paused

func toggle_pause():
	m_paused = !m_paused
