class_name ViewCard
extends AView

@export_category("Nodes")
@export var ParentNode: Control
@export var TitleLabel: RichTextLabel
@export var HoverNode: Control

@export_category("Visuals")
@export var HoverSize: float = 1.2

const BBCODE_CENTER: String = "[center]"

func _ready():
	ParentNode.mouse_entered.connect(mouse_entered_received)
	ParentNode.mouse_exited.connect(mouse_exited_received)

func update(p_card: ModelResourceCard):
	TitleLabel.text = str(BBCODE_CENTER, p_card.DisplayNameKey)

func mouse_entered_received():
	HoverNode.visible = true
	ParentNode.scale = Vector2.ONE * HoverSize
	ParentNode.z_index = 1

func mouse_exited_received():
	HoverNode.visible = false
	ParentNode.scale = Vector2.ONE
	ParentNode.z_index = 0
