class_name FeatureCardPlay
extends AFeature

# Model Resources
@export var HandConfig: ConfigHand
@export var StartingDeck: ModelResourceDeck

# View Scenes

# Model Instances
var m_modelHand: ModelHand
var m_modelTurnOrder: ModelTurnOrder

# Views

# Controllers

func init_models():
	m_modelHand = ModelHand.new()
	m_modelTurnOrder = ModelTurnOrder.new()

func init_controllers():
	kickstart(ControllerHandManager.new(
			m_modelHand,
			HandConfig)
	)
	kickstart(ControllerCardDrawer.new(
			m_modelTurnOrder,
			m_modelHand,
			StartingDeck)
	)

func on_initialized():
	StartingDeck.instantiate()
	StartingDeck.shuffle()
	m_modelTurnOrder.iterate()
