class_name AEffectController
extends AController

# Private
var m_effectType: Script

func register_effects():
	m_effectType = effect_type()
	UtilityReaction.on_card_added.connect(on_card_added_received)
	UtilityReaction.on_card_removed.connect(on_card_removed_received)
	
	for card in UtilityReaction.m_cards:
		connect_to_effect_signal(card)

func on_card_added_received(p_card: ModelResourceCard):
	connect_to_effect_signal(p_card)

func on_card_removed_received(p_card: ModelResourceCard):
	for reaction in p_card.Reactions:
		for effect in reaction.Effects:
			if effect.get_script() == m_effectType:
				effect.on_activated.disconnect(execute_effect)

func connect_to_effect_signal(p_card: ModelResourceCard):
	for reaction in p_card.Reactions:
		for effect in reaction.Effects:
			if effect.get_script() == m_effectType:
				effect.on_activated.connect(execute_effect)

# Virtual
func effect_type() -> Script: return AEffect

func execute_effect(p_card: ModelResourceCard, p_effect: AEffect):
	pass
