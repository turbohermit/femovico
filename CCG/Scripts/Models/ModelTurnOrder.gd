class_name ModelTurnOrder
extends AModel

enum EPhase
{
	START = 0,
	DRAW = 1,
	PLAY = 2,
	END = 3
}

var PlayerIndex: int
var Phase: EPhase
var PlayerAmount: int

signal on_updated(p_model: ModelTurnOrder)

func _init(p_playerAmount: int):
	PlayerAmount = p_playerAmount
	Phase = EPhase.START

func iterate():
	var phaseIndex: int = (Phase as int) + 1
	
	if phaseIndex == EPhase.size():
		phaseIndex = 0 
		PlayerIndex += 1
	
	if PlayerIndex == PlayerAmount:
		PlayerIndex = 0
	
	Phase = phaseIndex as EPhase
	on_updated.emit(self)

func phase_to_string() -> String:
	return str("Phase: ", EPhase.keys()[Phase])

func player_to_string() -> String:
	return str("Player: ", (PlayerIndex + 1))
