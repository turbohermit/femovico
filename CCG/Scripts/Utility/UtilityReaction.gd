extends Node

enum ETrigger
{
	NONE,
	ON_PLAY,
	ON_DRAW,
	ON_DISCARD,
	ON_DESTROY
}

var m_cards: Array[ModelResourceCard]

signal on_card_added(p_card: ModelResourceCard)
signal on_card_removed(p_card: ModelResourceCard)

func register_card(p_card: ModelResourceCard):
	m_cards.append(p_card)
	on_card_added.emit(p_card)

func deregister_card(p_card: ModelResourceCard):
	m_cards.erase(p_card)
	on_card_removed.emit(p_card)

func trigger_card(p_card: ModelResourceCard, p_trigger: ETrigger):
	for i in p_card.Reactions.size():
		var reaction: ModelResourceReaction = p_card.Reactions[i]
		if reaction.Trigger == p_trigger:
			reaction.execute()
