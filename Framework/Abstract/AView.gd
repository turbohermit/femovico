class_name AView
extends Node

signal on_terminated(p_view: AView)

func _ready():
	name = str(self, get_class()) 
	on_initialized()

func _process(p_deltaTime: float):
	update_tick(p_deltaTime)

func terminate(p_signal: bool = true):
	if p_signal:
		emit_signal("on_terminated", self)
	queue_free()

func update_tick(p_deltaTime: float):
	pass

func on_initialized():
	pass
