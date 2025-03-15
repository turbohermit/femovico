class_name ModelResourceCard
extends AModelResource

@export_category("Display")
@export var DisplayNameKey: StringName = "Card"

@export_category("Reactions")
@export var Reactions: Array[ModelResourceReaction]

# Signals
signal on_played(p_card: ModelResourceCard)

func instantiate() -> ModelResourceCard:
	var instance: ModelResourceCard = self.duplicate(true)
	UtilityReaction.register_card(instance)
	return instance

func play():
	on_played.emit(self)

func destroy():
	UtilityReaction.deregister_card(self)

func activate_trigger(p_trigger: UtilityReaction.ETrigger):
	for i in Reactions.size():
		if Reactions[i].Trigger == p_trigger:
			Reactions[i].activate()
