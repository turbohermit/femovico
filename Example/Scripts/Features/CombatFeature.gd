class_name CombatFeature
extends AFeature

@export_category("Model Resources")
@export var SpawnerResource: SpawnerModelResource

@export_category("View Scenes")
@export var EnemyViewScene: PackedScene

func init_models():
	Models.kickstart_model_resource(SpawnerResource)

func init_controllers():
	kickstart(ContSpawn.new())
	kickstart(ContMovement.new())
	kickstart(ContHealth.new())
