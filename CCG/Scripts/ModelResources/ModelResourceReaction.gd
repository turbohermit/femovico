class_name ModelResourceReaction
extends AModelResource

# Replace with your own data.
@export_category("Placeholder")
@export var Trigger: UtilityReaction.ETrigger
@export var Effects: Array[AEffect]

func activate():
	for i in Effects.size():
		Effects[i].activate()
