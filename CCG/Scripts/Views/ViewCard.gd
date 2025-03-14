class_name ViewCard
extends ADropView

# Serialized
@export_category("Nodes")
@export var ParentNode: Control
@export var TitleLabel: RichTextLabel

@export_category("Visuals")
@export var HoverSize: float = 1.2
@export var HoverVisualNode: Control

# Constants
const BBCODE_CENTER: String = "[center]"

# Private
var m_hovering: bool = false
var m_dragging: bool = false

# Signals
signal on_drag_start(p_view: ViewCard)

func update(p_card: ModelResourceCard):
	TitleLabel.text = str(BBCODE_CENTER, p_card.DisplayNameKey)

func update_drag(p_position: Vector2):
	m_dragging = true
	ParentNode.position = p_position - ParentNode.pivot_offset
	ParentNode.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ParentNode.z_index = 2

func on_hovered(p_state: bool):
	HoverVisualNode.visible = p_state
	ParentNode.scale = Vector2.ONE * (HoverSize if p_state else 1.0)
	ParentNode.z_index = 1 if p_state else 0
	m_hovering = p_state

func _input(p_event: InputEvent):
	if not m_hovering or not p_event is InputEventMouseButton:
		return
	
	var event: InputEventMouseButton = p_event as InputEventMouseButton
	if event.button_index != 1:
		return
	
	if event.pressed:
		on_drag_start.emit(self)
