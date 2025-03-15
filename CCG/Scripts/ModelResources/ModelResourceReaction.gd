class_name ModelResourceReaction
extends AModelResource

# Replace with your own data.
@export_category("Placeholder")
@export var Trigger: UtilityReaction.ETrigger
@export var Effects: Array[AEffect]

func instantiate() -> ModelResourceReaction:
	var instance: ModelResourceReaction = self.duplicate(true)
	for i in Effects.size():
		instance.Effects[i] = Effects[i].duplicate(true)
	
	return instance

func activate(p_card: ModelResourceCard):
	for i in Effects.size():
		Effects[i].activate(p_card)
