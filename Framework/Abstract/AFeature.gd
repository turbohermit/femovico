# AFeature is the base class for Features.
# Features are Resources that act as a factory for Model, Controller and View initialization.
class_name AFeature
extends Resource

# Public
@export var ViewRootIndex: int

# Instanced
var m_root: Node
var m_viewCollection: ViewCollection
var m_controllers: Array[AController]
var m_subfeatures: Array[AFeature]

# Signals
signal on_terminated(p_feature: AFeature)

# Creates and initializes an instance of this Feature Resource and returns it.
func initialize(p_root: Node, p_optionalParams: Array[Object] = []) -> AFeature:
	var feature = self.duplicate()
	
	feature.m_root = p_root
	feature.m_viewCollection = ViewCollection.new(p_root, ViewRootIndex )
	
	feature.init_parameters(p_optionalParams)
	feature.init_models()
	feature.init_views()
	feature.init_controllers()
	feature.on_initialized()
	
	print(str(feature.get_script().get_global_name(), " initialized."))
	return feature as AFeature

# Creates and tracks Controller instaces from the Feature.
func kickstart(p_controller: AController):
	p_controller.m_root = m_root
	p_controller.m_viewCollection = ViewCollection.new(m_root, ViewRootIndex + m_controllers.size())
	p_controller.on_initialized()
	p_controller.on_terminated.connect(on_controller_terminated_received)
	m_controllers.append(p_controller)
	return p_controller

func kickstart_sub_feature(p_feature: AFeature, p_optionalParams: Array[Object] = []):
	var instance = p_feature.initialize(m_root, p_optionalParams)
	instance.on_terminated.connect(on_subfeature_terminated_received)
	m_subfeatures.append(instance)
	return instance

# Call update_tick on tracked Controllers, then on tracked Views.
func update_tick(p_deltaTime: float):
	for controller in m_controllers:
		controller.update_tick(p_deltaTime)
	for subfeature in m_subfeatures:
		subfeature.update_tick(p_deltaTime)
	m_viewCollection.update_tick(p_deltaTime)

# Terminates all Views in the ViewCollection and then all tracked Controllers.
func terminate(p_signal: bool = true):
	print(str("Terminating feature:", get_script().get_global_name()))
	
	if m_viewCollection != null:
		m_viewCollection.terminate()
		m_viewCollection = null
	
	var controllerCount = m_controllers.size()
	for i in controllerCount:
		m_controllers[i].terminate(false)
	m_controllers.clear()
	
	var featureCount = m_subfeatures.size()
	for i in featureCount:
		m_subfeatures[i].terminate(false)
	m_subfeatures.clear()
	
	m_root = null
	if p_signal:
		on_terminated.emit(self)

func has_controller_type(p_controllerType: Variant) -> bool:
	for controller in m_controllers:
		if is_instance_of(controller, p_controllerType):
			return true
	return false

func has_subfeature_type(p_featureType: Variant) -> bool:
	for feature in m_subfeatures:
		if is_instance_of(feature, p_featureType):
			return true
	return false

func on_controller_terminated_received(p_controller: AController):
	m_controllers.erase(p_controller)

func on_subfeature_terminated_received(p_subfeature: AFeature):
	m_subfeatures.erase(p_subfeature)

# Virtual method for assigning optional parameters passed through the "initialize" function
func init_parameters(_p_optionalParams: Array[Object]):
	pass

# Virtual method to implement initializing Models.
func init_models():
	pass

# Virtual method to implement initializing Views.
func init_views():
	pass

# Virtual method to implement initializion Controllers.
func init_controllers():
	pass

# Called after Views and Controllers are initialized.
func on_initialized():
	pass
