class_name AViewControl
extends Control

signal on_terminated(p_view: AViewControl)

func _ready():
	name = str(self, get_class()) 

func _process(p_deltaTime: float):
	update_tick(p_deltaTime)

func terminate():
	emit_signal("on_terminated", self)
	queue_free()

func update_tick(p_deltaTime: float):
	pass
