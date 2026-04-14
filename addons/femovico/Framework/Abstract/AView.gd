class_name AView
extends Node

# Signals
signal on_terminated(p_view: AView)

# Virtual implementtions.
func _ready():
	on_initialized()

func _process(p_deltaTime: float):
	update_tick(p_deltaTime)

# Public functions.
func terminate(p_signal: bool = true):
	on_terminate()
	if p_signal:
		on_terminated.emit(self)
	queue_free()

func add_to_parent_hierarchy(p_parent: Node):
	if p_parent.is_node_ready():
		p_parent.add_child(self)
	else:
		await p_parent.ready
		p_parent.add_child(self)

# Virtual functions.
func update_tick(_p_deltaTime: float):
	pass

func on_initialized():
	pass

func on_terminate():
	pass
