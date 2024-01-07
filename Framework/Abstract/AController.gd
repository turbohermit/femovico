class_name AController
func get_class_name(): return "AController"

var m_root: Control
var m_viewCollection: ViewCollection = ViewCollection.new()

# Called after _init is called and m_root is assigned
func after_init():
	pass

func terminate():
	print(str("Terminating controller: ", get_class_name()))
	
	m_viewCollection.terminate()
	m_viewCollection = null
	
	m_root = null
