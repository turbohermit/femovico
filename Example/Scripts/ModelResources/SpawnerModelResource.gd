class_name SpawnerModelResource
extends AModelResource
func get_class_name(): return "SpawnerModelResource"

@export_category("Spawn Values")
@export var TimeBeforeSpawn: float = 5
@export var MaximumLivingSpawns: int = 50

# Replace with your own data.
@export_category("Creatures")
@export var Creatures: Array[CreatureModelResource]

# It's good practice to seperate runtime Model instances from ModelResources,
# So you don't accidentally change serialized values.
# Having some functions to Get data in a specific way is fine though!
func get_creature(p_index: int) -> CreatureModelResource:
	if p_index < 0 or p_index >= Creatures.size():
		print(str("Index ", p_index, " out of range"))
		return null
	return Creatures[p_index]
