class_name ModelSpawner
extends AModel

# Private
var m_countdown: float
var m_spawnTime: float

# Signals
signal on_spawn

# Public functions.
func update(p_resource: MRSpawner):
	m_spawnTime = p_resource.TimeBeforeSpawn
	m_countdown = m_spawnTime

func countdown(p_deltaTime: float):
	m_countdown -= p_deltaTime
	if m_countdown > 0:
		return
	
	on_spawn.emit()
	m_countdown = m_spawnTime
