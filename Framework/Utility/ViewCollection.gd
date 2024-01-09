# ViewCollection tracks views created from Controllers and Features.
class_name ViewCollection

var m_views: Array[AView]

# Creates a new empty view
func kickstart_view(p_view: AView, p_parent: Node):
	m_views.append(p_view)
	p_view.on_terminated.connect(view_terminated_received)
	
	p_parent.add_child.call_deferred(p_view)
	return p_view as AView

# Returns the first view of the type of input class name.
func kickstart_view_scene(p_viewScene: PackedScene, p_parent: Node):
	var scene = p_viewScene.instantiate()
	if not scene is AView:
		print(str("Trying to instantiate a View scene but the scene root is not a View: ", p_viewScene))
		scene.queue_free()
		return null
	
	var view = scene as AView
	m_views.append(view)
	view.on_terminated.connect(view_terminated_received)

	p_parent.add_child.call_deferred(view)
	return view as AView

# Returns the first view of the type of input class name.
func get_view_of_type(p_type: String) -> AView:
	for view in m_views:
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
