class_name AView2D
extends Node2D

signal on_terminated(p_view: AView2D)

func _ready():
	name = str(self, get_class()) 

func _process(p_deltaTime: float):
	if(GameStateUtility.Paused):
		return
	update_tick(p_deltaTime)

func terminate():
	emit_signal("on_terminated", self)
	queue_free()

func update_tick(p_deltaTime: float):
	pass
