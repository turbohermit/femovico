class_name ControllerHandManager
extends AController

# Constants
var DRAG_KEY: StringName = "DRAGGING_VIEW"

# Models
var m_hand: ModelHand
var m_config: ConfigHand

# Views
var m_handView: ViewHand
var m_inputView: ViewInput
var m_draggingCard: ModelResourceCard
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
	m_inputView.on_drag_position.connect(on_drag_position_received)

func on_initialized():
	m_handView = kickstart("VIEW_HAND", m_config.HandViewScene)

func change_order(p_viewToInsert: ViewCard, p_viewToShift: ViewCard):
	var newIndex: int = p_viewToShift.get_index()
	m_handView.HandContainer.move_child(p_viewToInsert, newIndex)

func drop_action(p_dropView: ADropView):
	match p_dropView.get_script():
		ViewCard:
			var originalView: ViewCard = m_viewCollection.get_view(m_draggingCard)
			change_order(originalView, p_dropView)
		ViewPlayArea:
			print("feest")

func on_added_received(_p_hand: ModelHand, p_card: ModelResourceCard):
	if m_viewCollection.has_key(p_card):
		return
	
	var view: ViewCard = kickstart(p_card, m_config.CardViewScene, m_handView.HandContainer)
	view.update(p_card)
	
	view.on_drag_start.connect(on_drag_start_received)

func on_removed_received(_p_hand: ModelHand, p_card: ModelResourceCard):
	if not m_viewCollection.has_key(p_card):
		return
	
	m_viewCollection.get_view(p_card).terminate()

func on_drag_start_received(p_view: ViewCard):
	if not m_viewCollection.has_view(p_view):
		return
	
	# Use original view as key, for easy retrieval.
	m_draggingView = kickstart(p_view, m_config.CardViewScene)
	m_draggingCard = m_viewCollection.get_key(p_view)
	m_draggingView.update(m_draggingCard)
	m_draggingView.update_drag(m_inputView.DragPosition)

func on_drag_release_received():
	if m_draggingView == null:
		return
	
	# If dropped on top of another card in your hand, change the order.
	var dropView = UtilityDragAndDrop.get_drop_view()
	if dropView != null:
		drop_action(dropView)
	
	m_draggingView.terminate()
	m_draggingView = null
	m_draggingCard = null

func on_drag_position_received(p_position: Vector2):
	if m_draggingView == null:
		return
	
	m_draggingView.update_drag(p_position)
