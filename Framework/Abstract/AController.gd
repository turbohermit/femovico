# AController is the base class for Controllers. 
# Controllers should only execute business logic between Models and Views.
class_name AController
func get_class_name(): return "AController"

var m_root: Node
var m_viewCollection: ViewCollection

signal on_terminated(p_controller: AController)

# Terminates all views in this controller's ViewCollection and unassigns local variables.
func terminate(p_signal: bool = true):
	print(str("Terminating controller: ", get_class_name()))
	on_terminate()
	m_viewCollection.terminate()
	m_viewCollection = null
	m_root = null
	if p_signal:
		on_terminated.emit(self)

# Called after _init and m_root is assigned.
func on_initialized():
	pass

# Called after terminate() for any custom cleanup implementation.
func on_terminate():
	pass

func update_tick(_p_deltaTime: float):
	pass
