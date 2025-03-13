class_name ModelHand
extends AModel

var Cards: Array[ModelResourceCard]

signal on_added(p_model: ModelHand, p_card: ModelResourceCard)
signal on_removed(p_model: ModelHand, p_card: ModelResourceCard)

func add_card(p_card: ModelResourceCard):
	Cards.append(p_card)
	on_added.emit(self, p_card)

func remove_card(p_card: ModelResourceCard):
	Cards.erase(p_card)
	on_removed.emit(self, p_card)
