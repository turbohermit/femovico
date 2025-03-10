class_name CombatFeature
extends AFeature

@export_category("Model Resources")
@export var SpawnerResource: SpawnerModelResource

@export_category("View Scenes")
@export var EnemyViewScene: PackedScene

func init_controllers():
	# Initializing a Model in Features is fine if you want to share it over multiple Controllers.
	# Just make sure to actually manipulate the data from the Controllers, not in the Feature.
	var liveEnemiesModel = LiveEnemiesModel.new()
	var randomModel = RandomModel.new()
	
	kickstart(
		SpawnController.new(liveEnemiesModel, randomModel, SpawnerResource, EnemyViewScene)
	)
	kickstart(
		MovementController.new(liveEnemiesModel, randomModel, SpawnerResource)
	)
	kickstart(
		HealthController.new(liveEnemiesModel)
	)
