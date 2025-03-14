## Singleton that handles registering and checking of ADropView,
## for an easy-to-use drag and drop system.
extends Node

var m_views: Array[ADropView]

func register_view(p_view: ADropView):
	if not m_views.has(p_view):
		m_views.append(p_view)

func deregister_view(p_view: ADropView):
	if m_views.has(p_view):
		m_views.erase(p_view)

func get_drop_view() -> ADropView:
	if m_views.is_empty():
		return null
	
	return m_views.back()
