class_name ControllerPhaseHandler
extends AController

# Models
var m_config: ConfigHud
var m_turnOrder: ModelTurnOrder

# Views
var m_phaseView: ViewPhaseIndicator

func _init(
p_modelTurnOrder: ModelTurnOrder,
p_config: ConfigHud):
	m_turnOrder = p_modelTurnOrder
	m_config = p_config
	
	m_turnOrder.on_updated.connect(on_turn_order_updated_recieved)

func on_initialized():
	m_phaseView = kickstart("VIEW", m_config.PhaseIndicatorViewScene)
	m_phaseView.on_end_phase.connect(on_end_phase_received)

func on_turn_order_updated_recieved(p_turnOrder: ModelTurnOrder):
	m_phaseView.update(p_turnOrder)

func on_end_phase_received():
	m_turnOrder.iterate()
