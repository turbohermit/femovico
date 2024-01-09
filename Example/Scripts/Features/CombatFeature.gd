class_name CombatFeature
extends AFeature
func get_class_name(): return "CombatFeature"

@export_category("Model Resources")
@export var SpawnerResource: SpawnerModelResource

@export_category("View Scenes")
@export var EnemyViewScene: PackedScene

# Model Instances

# Views

# Controllers

func init_controllers():
	# Initializing a Model in Features is fine if you want to share it over multiple Controllers.
	# Just make sure to actually manipulate the data from the Controllers, not in the Feature.
	var liveEnemiesModel = LiveEnemiesModel.new()
	
	kickstart(
		SpawnController.new(SpawnerResource, liveEnemiesModel, EnemyViewScene)
	)
	
	kickstart(
		MovementController.new(liveEnemiesModel)
	)
	
	kickstart(
		HealthController.new(liveEnemiesModel)
	)
