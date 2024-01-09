class_name SpawnerModel
extends AModel
func get_class_name(): return "SpawnerModel"

var m_generator: RandomNumberGenerator
var m_countdown: float
var m_spawnTime: float
var m_maxPickRange: int

signal on_spawn

func _init(p_resource: SpawnerModelResource):
	m_spawnTime = p_resource.TimeBeforeSpawn
	m_countdown = m_spawnTime
	
	m_maxPickRange = p_resource.Creatures.size() - 1
	m_generator = RandomNumberGenerator.new()

func pick_creature_index() -> int:
	return m_generator.randi_range(0, m_maxPickRange)

func update_tick(p_deltaTime: float):
	m_countdown -= p_deltaTime
	if m_countdown > 0:
		return
	
	on_spawn.emit()
	m_countdown = m_spawnTime
