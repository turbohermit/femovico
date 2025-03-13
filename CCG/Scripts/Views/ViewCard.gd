class_name ViewCard
extends AView

# Serialized
@export_category("Nodes")
@export var ParentNode: Control
@export var TitleLabel: RichTextLabel
@export var HoverNode: Control

@export_category("Visuals")
@export var HoverSize: float = 1.2

# Constants
const BBCODE_CENTER: String = "[center]"

# Private
var m_hovering: bool = false

# Signals
signal on_drag_start(p_view: ViewCard)
signal on_drag_end(p_view: ViewCard)

func _ready():
	ParentNode.mouse_entered.connect(mouse_entered_received)
	ParentNode.mouse_exited.connect(mouse_exited_received)

func update(p_card: ModelResourceCard):
	TitleLabel.text = str(BBCODE_CENTER, p_card.DisplayNameKey)

func update_drag(p_position: Vector2):
	ParentNode.position = p_position - ParentNode.pivot_offset

func mouse_entered_received():
	HoverNode.visible = true
	ParentNode.scale = Vector2.ONE * HoverSize
	ParentNode.z_index = 1
	m_hovering = true

func mouse_exited_received():
	HoverNode.visible = false
	ParentNode.scale = Vector2.ONE
	ParentNode.z_index = 0
	m_hovering = false

func _input(p_event: InputEvent):
	if not m_hovering or not p_event is InputEventMouseButton:
		return
	
	var event: InputEventMouseButton = p_event as InputEventMouseButton
	if event.button_index != 1:
		return
	
	if event.pressed:
		on_drag_start.emit(self)
