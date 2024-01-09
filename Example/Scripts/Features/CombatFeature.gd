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
	var liveEnemiesModel = LiveEnemiesModel.new()
	
	kickstart(
		SpawnController.new(SpawnerResource, liveEnemiesModel, EnemyViewScene)
	)
	kickstart(
		MovementController.new(liveEnemiesModel)
	)
