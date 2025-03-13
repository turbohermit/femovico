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

signal on_updated(p_model: ModelTurnOrder)

func _init():
	Phase = EPhase.START

func iterate():
	if Phase == EPhase.END:
		Phase = EPhase.START
		PlayerIndex += 1
		on_updated.emit(self)
		return
	
	Phase = (1 + Phase as int) as EPhase
	on_updated.emit(self)

func phase_to_string() -> String:
	return str("Phase: ", EPhase.keys()[Phase])

func player_to_string() -> String:
	return str("Player: ", (PlayerIndex + 1))
