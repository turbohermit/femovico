# ViewCollection tracks views created from Controllers and Features.
class_name ViewCollection

var m_views: Array[AView]

# Creates a new empty view
func create_view(p_view: AView, p_parent: Control):
	m_views.append(p_view)
	p_view.connect("on_terminated", view_terminated_received)
	
	p_parent.add_child.call_deferred(p_view)
	return p_view as AView

# Returns the first view of the type of input class name.
func create_view_from_scene(p_view: PackedScene, p_parent: Control):
	var scene = p_view.instantiate()
	if not(scene is AView):
		print(str("Trying to instantiate scene but it is not a view: ", p_view))
		scene.queue_free()
		return null
	
	var view = scene as AView
	m_views.append(view)
	view.connect("on_terminated", view_terminated_received)

	p_parent.add_child.call_deferred(view)
	return view as AView

# Returns the first view of the type of input class name.
func get_view_of_type(p_type: String) -> AView:
	for view in m_views:
		if(view.get_class_name() == p_type):
			return view
	return null

# When an individual view is terminated from anywhere, remove it from the collection.
func view_terminated_received(p_view: AView):
	if not m_views.has(p_view):
		return
	
	p_view.disconnect("on_terminated", view_terminated_received)
	m_views.erase(p_view)

# Terminates each view in this collection in reverse order.
func terminate():
	for i in range(m_views.size() - 1, -1, -1):
		var view = m_views[-i-1]
		if not view == null:
			view.terminate()
		view = null
	m_views.clear()
