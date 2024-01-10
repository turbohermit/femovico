# AView is the base class for Views.
# Views are representations of Models and can be interacted with by the user.
# They have to inherit from Node and be placed somewhere in the hierarchy.
class_name AView
extends Node

signal on_terminated(p_view: AView)

func _ready():
	name = str(self, get_class()) 

# Signals that it's being terminated, so any subscribers can react accordingly.
# Then it removes itself from the hierarchy.
func terminate():
	on_terminated.emit(self)
	queue_free()

# This is called 
func update_tick(p_deltaTime: float):
	pass
