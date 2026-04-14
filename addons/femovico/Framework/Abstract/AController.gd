# AController is the base class for Controllers. 
# Controllers should only execute business logic between Models and Views.
class_name AController
extends RefCounted

# "Protected"
var Views: ViewCollection
var Models: ModelCollection

# "Private" 
var m_root: Node

# Signals
signal on_terminated(p_controller: AController)

# Terminates all views in this controller's ViewCollection and unassigns local variables.
func terminate(p_signal: bool = true):
	on_terminate()
	Views.terminate()
	Views = null
	m_root = null
	if p_signal:
		on_terminated.emit(self)

func kickstart(p_key: Variant, p_viewScene: PackedScene, p_parent: Node = m_root) -> AView:
	return Views.kickstart(p_key, p_viewScene, p_parent)

# Virtual functions.
# Called after _init and m_root is assigned, but before on_models and on_intialized.
func on_pre_initialized():
	pass

# Called after on_pre_initialized.
func on_models():
	pass

# Called after on_models().
func on_initialized():
	pass

# Called after terminate() for any custom cleanup implementation.
func on_terminate():
	pass

func update_tick(_p_deltaTime: float):
	pass
