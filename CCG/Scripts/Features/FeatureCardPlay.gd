class_name FeatureCardPlay
extends AFeature

# Model Resources
@export_category("Configs")
@export var HandConfig: ConfigHand
@export var DeckConfig: ConfigDeck
@export var HudConfig: ConfigHud

@export_category("View Scenes")
@export var InputViewScene: PackedScene

# Model Instances
var m_modelHand: ModelHand
var m_modelTurnOrder: ModelTurnOrder

# View Instances
var m_viewInput: ViewInput

func init_models():
	m_modelHand = ModelHand.new()
	m_modelTurnOrder = ModelTurnOrder.new()

func init_views():
	m_viewInput = m_viewCollection.kickstart("INPUT", InputViewScene)

func init_controllers():
	kickstart(ControllerHandManager.new(
		m_modelHand,
		HandConfig,
		m_viewInput
	))
	kickstart(ControllerCardDrawer.new(
		m_modelTurnOrder,
		m_modelHand,
		DeckConfig
	))
	kickstart(ControllerPhaseHandler.new(
		m_modelTurnOrder,
		HudConfig
	))

func on_initialized():
	DeckConfig.StartingDeck.instantiate()
	DeckConfig.StartingDeck.shuffle()
	m_modelTurnOrder.iterate()
