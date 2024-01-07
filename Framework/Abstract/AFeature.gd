class_name AFeature
extends Resource
func get_class_name(): return "AFeature"

var m_root: Control
var m_viewCollection: ViewCollection
var m_controllers: Array[AController]
var m_featureInitializer: FeatureInitializer

func initialize(p_root: Control, p_createInstance: bool = true, p_featureInitializer: FeatureInitializer = null) -> AFeature:
	var feature = self
	if p_createInstance:
		feature = self.duplicate()
	
	feature.m_root = p_root
	feature.m_featureInitializer = p_featureInitializer
	feature.m_viewCollection = ViewCollection.new()
	feature.init_views()
	feature.init_controllers()
	feature.on_initialized()
	print(str(feature.get_class_name(), " initialized."))
	return feature as AFeature

func kickstart(p_controller: AController):
	p_controller.m_root = m_root
	p_controller.after_init()
	m_controllers.append(p_controller)
	return p_controller

func terminate():
	print(str("Terminating feature:", get_class_name()))
	
	m_viewCollection.terminate()
	m_viewCollection = null
	
	for controller in m_controllers:
		controller.terminate()
		controller = null
	m_controllers.clear()
	
	m_root = null

func init_views():
	pass

func init_controllers():
	pass

func on_initialized():
	pass

func update_tick(p_deltaTime: float):
	pass
