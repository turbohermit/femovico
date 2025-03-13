class_name ViewCard
extends AView

@export_category("Nodes")
@export var ParentNode: Control
@export var TitleLabel: RichTextLabel

func _ready():
	pass

func update(p_card: ModelResourceCard):
	TitleLabel.text = p_card.DisplayNameKey
