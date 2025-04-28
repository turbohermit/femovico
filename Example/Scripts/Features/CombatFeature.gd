class_name CombatFeature
extends AFeature

@export_category("Model Resources")
@export var SpawnerResource: SpawnerModelResource

@export_category("View Scenes")
@export var EnemyViewScene: PackedScene

func init_controllers():
	kickstart(
		SpawnController.new(SpawnerResource, EnemyViewScene)
	)
	kickstart(
		MovementController.new(SpawnerResource)
	)
	kickstart(
		HealthController.new()
	)
