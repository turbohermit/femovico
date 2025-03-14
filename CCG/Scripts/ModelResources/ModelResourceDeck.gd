class_name ModelResourceDeck
extends AModelResource

# Serialized
@export var DefaultCards: Array[ModelResourceCard]

# Accessors
var CardCount: int:
	get: return m_instances.size()
var Cards: Array[ModelResourceCard]:
	get: return m_instances

# Private
var m_instances: Array[ModelResourceCard]

signal on_order_changed
signal on_empty

func instantiate():
	for i in DefaultCards.size():
		var instance: ModelResourceCard = DefaultCards[i].duplicate(true)
		m_instances.append(instance)

func shuffle():
	m_instances.shuffle()
	on_order_changed.emit()

func draw_cards(p_amount: int) -> Array[ModelResourceCard]:
	if m_instances.size() == 0:
		print("Deck empty")
		on_empty.emit()
		return []
	
	var count: int = min(p_amount, m_instances.size())
	var toDraw: Array[ModelResourceCard] = m_instances.slice(0, count)
	remove_cards(count)
	
	return toDraw

func insert_card(p_card: ModelResourceCard, p_index: int = 0):
	m_instances.insert(p_index, p_card)
	on_order_changed.emit()

func remove_cards(p_amount: int):
	for i in p_amount:
		m_instances.remove_at(0)
	
	if m_instances.size() == 0:
		on_empty.emit()
