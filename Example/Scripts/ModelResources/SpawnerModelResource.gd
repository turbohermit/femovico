class_name SpawnerModelResource
extends AModelResource

@export_category("Spawn Values")
@export var TimeBeforeSpawn: float = 5
@export var MaximumLivingSpawns: int = 50
@export var MaximumRange: float = 100

@export_category("Creatures")
@export var Creatures: Array[CreatureModelResource]

@export_category("View Scenes")
@export var EnemyViewScene: PackedScene

var CreatureCount:
	get:
		return Creatures.size()

# It's good practice to seperate runtime Model instances from ModelResources,
# So you don't accidentally change serialized values.
# Having some functions to Get data in a specific way is fine though!
func get_creature(p_index: int) -> CreatureModelResource:
	if Creatures.size() == 0:
		print(str("No creatures assigned!"))
		return null
	
	if p_index < 0 or p_index >= Creatures.size():
		print(str("Index ", p_index, " out of range"))
		return null
	return Creatures[p_index]
