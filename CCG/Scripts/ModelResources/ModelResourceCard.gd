class_name ModelResourceCard
extends AModelResource

@export var DisplayNameKey: StringName = "Card"

# Signals
signal on_played(p_card: ModelResourceCard)

func play():
	on_played.emit(self)
