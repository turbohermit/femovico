class_name ModelPlayArea
extends AModel

# Dictionary with key Player index and value Array[ModelResourceCards]
var Cards: Dictionary

signal on_added(p_model: ModelPlayArea, p_card: ModelResourceCard)
signal on_removed(p_model: ModelPlayArea, p_card: ModelResourceCard)

func add_card(p_playerIndex: int, p_card: ModelResourceCard):
	if not Cards.has(p_playerIndex):
		Cards[p_playerIndex] = [ModelResourceCard]
	
	Cards[p_playerIndex].append(p_card)
	on_added.emit(self, p_card)

func remove_card(p_card: ModelResourceCard):
	for playerIndex in Cards:
		for card in Cards[playerIndex]:
			if p_card != card:
				continue
			
			Cards[playerIndex].erase(p_card)
			on_removed.emit(self, p_card)
			return
