class_name ContSpawn
extends AController

# ModelResources
var m_spawnerResource: MRSpawner

# Models
var m_spawnerModel: ModelSpawner

# Virtual implementations.
func on_models():
	m_spawnerModel = Models.fetch(ModelSpawner)
	m_spawnerResource = Models.fetch(MRSpawner)
	
	m_spawnerModel.update(m_spawnerResource)
	m_spawnerModel.on_spawn.connect(on_spawn_received)

# Arguably this should be from a signal on a model, but whatever.
func update_tick(p_deltaTime: float):
	m_spawnerModel.countdown(p_deltaTime)

# Private funtions.
func spawn(p_liveEnemies: ModelLiveEnemies):
	var random = Models.fetch(ModelRandom)
	var index = random.range(m_spawnerResource.CreatureCount)
	var creature: MRCreature = m_spawnerResource.get_creature(index)
	var model: ModelEnemy = ModelEnemy.new(creature)
	p_liveEnemies.add_enemy(model)

# Signal implementations.
func on_spawn_received():
	var liveEnemies: ModelLiveEnemies = Models.fetch(ModelLiveEnemies)
	if liveEnemies.Count >= m_spawnerResource.MaximumLivingSpawns:
		return
	
	spawn(liveEnemies)
