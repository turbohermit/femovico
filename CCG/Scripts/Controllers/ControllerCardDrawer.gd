class_name ControllerCardDrawer
extends AEffectController

# Models
var m_turnOrder: ModelTurnOrder
var m_hand: ModelHand
var m_config: ConfigDeck
var m_deck: ModelResourceDeck

# Views
var m_deckView: ViewDeck

func effect_type() -> Script: return EffectDraw

func _init(
p_turnOrder: ModelTurnOrder,
p_hand: ModelHand,
p_config: ConfigDeck):
	m_turnOrder = p_turnOrder
	m_hand = p_hand
	m_config = p_config
	m_deck = p_config.StartingDeck
	
	m_turnOrder.on_updated.connect(on_turn_order_updated_received)
	register_effects()

func on_initialized():
	m_deckView = kickstart(m_deck, m_config.DeckViewScene)
	m_deckView.update(m_deck)

func on_turn_order_updated_received(p_model: ModelTurnOrder):
	if p_model.Phase != ModelTurnOrder.EPhase.DRAW:
		return
	
	draw_cards(3)
	m_turnOrder.iterate()

func draw_cards(p_amount: int):
	var cards: Array[ModelResourceCard] = m_deck.draw_cards(p_amount)
	m_deckView.update(m_deck)
	
	for card in cards:
		m_hand.add_card(card)

func execute_effect(_p_card: ModelResourceCard, p_effect: AEffect):
	var drawEffect: EffectDraw = p_effect as EffectDraw
	draw_cards(drawEffect.CardAmount)
