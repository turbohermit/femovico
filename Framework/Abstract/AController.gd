# AController is the base class for Controllers. 
# Controllers should only execute business logic between Models and Views.
class_name AController
func get_class_name(): return "AController"

var m_root: Control
var m_viewCollection: ViewCollection = ViewCollection.new()

# Terminates all views in this controller's ViewCollection and unassigns local variables.
func terminate():
	print(str("Terminating controller: ", get_class_name()))
	m_viewCollection.terminate()
	m_viewCollection = null
	m_root = null
	on_terminate()

# Called after _init and m_root is assigned.
func after_init():
	pass

# Called after terminate() for any custom cleanup implementation.
func on_terminate():
	pass
