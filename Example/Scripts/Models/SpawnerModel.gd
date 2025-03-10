class_name SpawnerModel
extends AModel

var m_countdown: float
var m_spawnTime: float

signal on_spawn

func _init(p_resource: SpawnerModelResource):
	m_spawnTime = p_resource.TimeBeforeSpawn
	m_countdown = m_spawnTime

func update_tick(p_deltaTime: float):
	m_countdown -= p_deltaTime
	if m_countdown > 0:
		return
	
	on_spawn.emit()
	m_countdown = m_spawnTime
