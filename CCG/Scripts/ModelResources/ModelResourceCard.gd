class_name ModelResourceCard
extends AModelResource

@export_category("Display")
@export var DisplayNameKey: StringName = "Card"

@export_category("Reactions")
@export var Reactions: Array[ModelResourceReaction]

# Signals
signal on_played(p_card: ModelResourceCard)
signal on_destroy(p_card: ModelResourceCard)
signal on_discard(p_card: ModelResourceCard)

func instantiate() -> ModelResourceCard:
	var instance: ModelResourceCard = self.duplicate(true)
	for i in Reactions.size():
		instance.Reactions[i] = Reactions[i].instantiate()
	
	UtilityReaction.register_card(instance)
	return instance

func play():
	activate_trigger(UtilityReaction.ETrigger.ON_PLAY)
	on_played.emit(self)

func destroy():
	activate_trigger(UtilityReaction.ETrigger.ON_DESTROY)
	UtilityReaction.deregister_card(self)
	on_destroy.emit(self)

func discard():
	activate_trigger(UtilityReaction.ETrigger.ON_DISCARD)
	UtilityReaction.deregister_card(self)
	on_discard.emit(self)

func activate_trigger(p_trigger: UtilityReaction.ETrigger):
	for i in Reactions.size():
		if Reactions[i].Trigger == p_trigger:
			Reactions[i].activate(self)
