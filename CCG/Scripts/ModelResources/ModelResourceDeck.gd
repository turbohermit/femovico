class_name ModelResourceDeck
extends AModelResource

@export var Cards: Array[ModelResourceCard]

var m_cards: Array[ModelResourceCard]

signal on_order_changed
signal on_empty

func instantiate():
	m_cards = Cards.duplicate()

func shuffle():
	m_cards.shuffle()
	on_order_changed.emit()

func draw_cards(p_amount: int) -> Array[ModelResourceCard]:
	if m_cards.size() == 0:
		on_empty.emit()
		return []
	
	var count: int = min(p_amount, m_cards.size())
	var toDraw: Array[ModelResourceCard] = m_cards.slice(0, count)
	remove_cards(count)
	
	return toDraw

func insert_card(p_card: ModelResourceCard, p_index: int = 0):
	m_cards.insert(p_index, p_card)
	on_order_changed.emit()

func remove_cards(p_amount: int):
	for i in p_amount:
		m_cards.remove_at(0)
	
	if m_cards.size() == 0:
		on_empty.emit()
