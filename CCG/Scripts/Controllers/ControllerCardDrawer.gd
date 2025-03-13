class_name ControllerCardDrawer
extends AController

# Models
var m_turnOrder: ModelTurnOrder
var m_hand: ModelHand
var m_deck: ModelResourceDeck

func _init(
p_turnOrder: ModelTurnOrder,
p_hand: ModelHand,
p_deck: ModelResourceDeck):
	m_turnOrder = p_turnOrder
	m_hand = p_hand
	m_deck = p_deck
	
	m_turnOrder.on_updated.connect(on_turn_order_updated_received)

func on_turn_order_updated_received(p_model: ModelTurnOrder):
	if p_model.Phase != ModelTurnOrder.EPhase.DRAW:
		return
	
	var cards: Array[ModelResourceCard] = m_deck.draw_cards(3)
	
	for card in cards:
		m_hand.add_card(card)
