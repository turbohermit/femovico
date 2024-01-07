# AFeature is the base class for Features.
# Features are Resources that act as a factory for Model, Controller and View initialization.
class_name AFeature
extends Resource
func get_class_name(): return "AFeature"

var m_root: Control
var m_viewCollection: ViewCollection
var m_controllers: Array[AController]

# Creates and initializes an instance of this Feature Resource and returns it.
func initialize(p_root: Control) -> AFeature:
	var feature = self.duplicate()
	
	feature.m_root = p_root
	feature.m_viewCollection = ViewCollection.new()
	
	feature.init_views()
	feature.init_controllers()
	feature.on_initialized()
	
	print(str(feature.get_class_name(), " initialized."))
	return feature as AFeature

# Creates and tracks Controller instaces from the Feature.
func kickstart(p_controller: AController):
	p_controller.m_root = m_root
	p_controller.after_init()
	m_controllers.append(p_controller)
	return p_controller

# Call update_tick on tracked Controllers, then on tracked Views.
func update_tick(p_deltaTime: float):
	for controller in m_controllers:
		controller.update_tick(p_deltaTime)
	
	m_viewCollection.update_tick(p_deltaTime)

# Terminates all Views in the ViewCollection and then all tracked Controllers.
func terminate():
	print(str("Terminating feature:", get_class_name()))
	
	m_viewCollection.terminate()
	m_viewCollection = null
	
	for controller in m_controllers:
		controller.terminate()
		controller = null
	m_controllers.clear()
	
	m_root = null

# Virtual method to implement initializing Views.
func init_views():
	pass

# Virtual method to implement initializion Controllers.
func init_controllers():
	pass

# Called after Views and Controllers are initialized.
func on_initialized():
	pass
