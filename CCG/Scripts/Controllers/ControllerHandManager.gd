class_name ControllerHandManager
extends AController

# Models
var m_hand: ModelHand
var m_config: ConfigHand

# Views
var m_handView: ViewHand
var m_inputView: ViewInput
var m_draggingView: ViewCard

func _init(
p_hand: ModelHand,
p_config: ConfigHand,
p_inputView: ViewInput):
	m_hand = p_hand
	m_config = p_config
	m_inputView = p_inputView
	
	m_hand.on_added.connect(on_added_received)
	m_hand.on_removed.connect(on_removed_received)
	m_inputView.on_drag_release.connect(on_drag_release_received)

func on_initialized():
	m_handView = kickstart("VIEW_HAND", m_config.HandViewScene)

func on_added_received(p_hand: ModelHand, p_card: ModelResourceCard):
	if m_viewCollection.has_key(p_card):
		return
	
	var view: ViewCard = kickstart(p_card, m_config.CardViewScene, m_handView.HandContainer)
	view.update(p_card)
	view.on_drag_start.connect(on_drag_start_received)

func on_removed_received(p_hand: ModelHand, p_card: ModelResourceCard):
	if not m_viewCollection.has_key(p_card):
		return
	
	m_viewCollection.get_view(p_card).terminate()

func on_drag_start_received(p_view: ViewCard):
	if not m_viewCollection.has_view(p_view):
		return
	
	print("draggy")
	m_draggingView = p_view

func on_drag_release_received():
	if m_draggingView == null:
		return
	
	print("releasy")
	m_draggingView = null
