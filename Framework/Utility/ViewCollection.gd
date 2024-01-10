# ViewCollection tracks Views created from Controllers and Features.
class_name ViewCollection

var m_views: Dictionary = {}

# Tracks a view created dynamically somewhere else.
func kickstart_view(p_model: AModel, p_view: AView, p_parent: Node) -> AView:
	m_views[p_model] = p_view
	p_view.on_terminated.connect(view_terminated_received)
	
	p_parent.add_child.call_deferred(p_view)
	return p_view

# Creates a View by instantiating the input packed scene.
func kickstart_view_scene(p_model: AModel, p_viewScene: PackedScene, p_parent: Node) -> AView:
	var scene = p_viewScene.instantiate()
	if not scene is AView:
		print(str("Trying to instantiate a View scene but the scene root is not a View: ", p_viewScene))
		scene.queue_free()
		return null
	
	var view = scene as AView
	m_views[p_model] = view
	view.on_terminated.connect(view_terminated_received)

	p_parent.add_child.call_deferred(view)
	return view

func get_view(p_model: AModel) -> AView:
	if not m_views.has(p_model):
		print(str("Model: ", p_model," not found in ViewCollection"))
		return null
	return m_views[p_model]

func get_model(p_view: AView) -> AModel:
	var key = m_views.find_key(p_view)
	if key == null:
		print(str("View: ", p_view," not found in ViewCollection"))
		return null
	return key

func has_model(p_model: AModel) -> bool:
	return m_views.has(p_model)

func has_view(p_view: AView) -> bool:
	return m_views.find_key(p_view) != null

# Returns the first View of the type of input class name.
func get_view_of_type(p_type: String) -> AView:
	for view in m_views.values():
		if(view.get_class_name() == p_type):
			return view
	return null

# Calls update_tick on each tracked View.
func update_tick(p_deltaTime: float):
	for view in m_views:
		view.update_tick(p_deltaTime)

# Terminates each view in this collection in reverse order.
func terminate():
	for i in range(m_views.size() - 1, -1, -1):
		var view = m_views[-i-1]
		if not view == null:
			view.terminate()
		view = null
	m_views.clear()

# When an individual view is terminated from anywhere, remove it from the collection.
func view_terminated_received(p_view: AView):
	if not m_views.has(p_view):
		return
	
	p_view.on_terminated.disconnect(view_terminated_received)
	m_views.erase(p_view)
