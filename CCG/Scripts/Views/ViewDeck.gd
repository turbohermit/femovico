class_name ViewDeck
extends AView

@export_category("Nodes")
@export var CardCountLabel: Label 

func update(p_deck: ModelResourceDeck):
	CardCountLabel.text = str(p_deck.CardCount)
