class_name ViewPhaseIndicator
extends AView

@export_category("Nodes")
@export var PhaseButton: Button
@export var PhaseInfoLabel: Label
@export var PlayerInfoLabel: Label

signal on_end_phase

func on_initialized():
	PhaseButton.pressed.connect(on_phase_button_pressed_received)

func update(p_model: ModelTurnOrder):
	PhaseInfoLabel.text = p_model.phase_to_string()
	PlayerInfoLabel.text = p_model.player_to_string()

func on_phase_button_pressed_received():
	on_end_phase.emit()
