## ModelResource that handles card effects.
## Inherit from AEffect for serialized gameplay effect data.
class_name AEffect
extends AModelResource

signal on_activated(p_card: ModelResourceCard, p_effect: AEffect)

func activate(p_card: ModelResourceCard):
	on_activated.emit(p_card, self)
