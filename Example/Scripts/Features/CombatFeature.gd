class_name CombatFeature
extends AFeature

@export_category("Model Resources")
@export var SpawnerResource: SpawnerModelResource

@export_category("View Scenes")
@export var EnemyViewScene: PackedScene

# Models
var m_liveEnemiesModel: LiveEnemiesModel
var m_randomModel: RandomModel

func init_models():
	# Initializing a Model in Features is fine if you want to share it over multiple Controllers.
	# Just make sure to actually manipulate the data from the Controllers, not in the Feature.
	m_liveEnemiesModel = LiveEnemiesModel.new()
	m_randomModel = RandomModel.new()

func init_controllers():
	
	kickstart(
		SpawnController.new(m_liveEnemiesModel, m_randomModel, SpawnerResource, EnemyViewScene)
	)
	kickstart(
		MovementController.new(m_liveEnemiesModel, m_randomModel, SpawnerResource)
	)
	kickstart(
		HealthController.new(m_liveEnemiesModel)
	)
