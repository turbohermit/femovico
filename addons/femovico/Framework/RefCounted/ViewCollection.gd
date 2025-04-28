# A ViewCollection tracks AView nodes kickstarted from Controllers.
# Each Controller has its own ViewCollection instance.
class_name ViewCollection
extends RefCounted

# Accessors
var Count:
	get: return m_keyToView.size()
var Keys:
	get: return m_keyToView.keys()

# "Private"
var m_root: Node
var m_keyToView: Dictionary = {}

func _init(p_root: Node):
	m_root = p_root

# Creates a View by instantiating the input packed scene.
func kickstart(p_key: Variant, p_viewScene: PackedScene, p_parent: Node = m_root) -> AView:
	if p_viewScene == null:
		print(str("Supplied view scene is null for key ", p_key))
		return null
	
	var scene = p_viewScene.instantiate()
	if not scene is AView:
		print(str("Trying to instantiate a View scene but the scene root is not a View: ", p_viewScene))
		scene.queue_free()
		return null
	
	var view = scene as AView
	append_view(p_key, view)
	
	# TODO: This is not a nice way of handling view sorting.
	p_parent.add_child.call_deferred(view)
	p_parent.move_child.call_deferred(view, -1)
	return view

func append_view(p_key: Variant, p_view: AView):
	m_keyToView[p_key] = p_view
	p_view.on_terminated.connect(view_terminated_received)

func get_view(p_key: Variant) -> AView:
	if not m_keyToView.has(p_key):
		print(str("Key ", p_key," not found in ViewCollection"))
		return null
	return m_keyToView[p_key]

func get_key(p_view: AView) -> Variant:
	var key = m_keyToView.find_key(p_view)
	if key == null:
		print(str("View: ", p_view," not found in ViewCollection"))
		return null
	return key

func has_model(p_model: AModel) -> bool:
	return m_keyToView.has(p_model)

func has_view(p_view: AView) -> bool:
	return m_keyToView.find_key(p_view) != null

func has_key(p_key: Variant) -> bool:
	return m_keyToView.has(p_key)

# Returns the first View of the type of input class name.
func get_view_of_type(p_type: Script) -> AView:
	for view in m_keyToView.values():
		if(view.get_script() == p_type):
			return view
	return null

# Calls update_tick on each tracked View.
func update_tick(p_deltaTime: float):
	for view in m_keyToView.values():
		view.update_tick(p_deltaTime)

# Terminates each view in this collection in reverse order.
func terminate():
	for model in m_keyToView:
		var view = m_keyToView[model]
		if not view == null:
			view.terminate(false)
	m_keyToView.clear()

# When an individual view is terminated from anywhere, remove it from the collection.
func view_terminated_received(p_view: AView):
	if not has_view(p_view):
		return
	
	var key = get_key(p_view)
	p_view.on_terminated.disconnect(view_terminated_received)
	m_keyToView.erase(key)
