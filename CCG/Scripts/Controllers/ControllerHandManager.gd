class_name ControllerHandManager
extends AController

# Models
var m_hand: ModelHand
var m_config: ConfigHand

# Views
var m_handView: ViewHand

func _init(
p_hand: ModelHand,
p_config: ConfigHand):
	m_hand = p_hand
	m_config = p_config
	
	m_hand.on_added.connect(on_added_received)
	m_hand.on_removed.connect(on_removed_received)

func on_initialized():
	m_handView = kickstart("VIEW_HAND", m_config.HandViewScene)

func on_added_received(p_hand: ModelHand, p_card: ModelResourceCard):
	if m_viewCollection.has_key(p_card):
		return
	
	var view: ViewCard = kickstart(p_card, m_config.CardViewScene, m_handView.HandContainer)
	view.update(p_card)

func on_removed_received(p_hand: ModelHand, p_card: ModelResourceCard):
	if not m_viewCollection.has_key(p_card):
		return
	
	m_viewCollection.get_view(p_card).terminate()
