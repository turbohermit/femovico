class_name ControllerCardPlayer
extends AController

# Models
var m_turnOrder: ModelTurnOrder
var m_playArea: ModelPlayArea
var m_hudConfig: ConfigHud
var m_handConfig: ConfigHand

# Views
var m_playAreaView: ViewPlayArea

func _init(
p_turnOrder: ModelTurnOrder,
p_playArea: ModelPlayArea,
p_deck: ModelResourceDeck,
p_hudConfig: ConfigHud,
p_handConfig: ConfigHand
):
	m_turnOrder = p_turnOrder
	m_playArea = p_playArea
	m_hudConfig = p_hudConfig
	m_handConfig = p_handConfig
	
	for card in p_deck.Cards:
		card.on_played.connect(on_played_received)

func on_initialized():
	m_playAreaView = kickstart("PLAY_AREA", m_hudConfig.PlayAreaViewScene)

func on_played_received(p_card: ModelResourceCard):
	var player: int = m_turnOrder.PlayerIndex
	m_playArea.add_card(player, p_card)
	
	var view: ViewCard = kickstart(p_card, m_handConfig.CardViewScene, m_playAreaView.get_area(player))
	view.update(p_card)
