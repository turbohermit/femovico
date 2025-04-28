class_name SpawnController
extends AController

# ModelResources
var m_spawnerResource: SpawnerModelResource

# Models
var m_spawnerModel: SpawnerModel

# Virtual implementations.
func on_models():
	m_spawnerModel = Models.fetch(SpawnerModel)
	m_spawnerResource = Models.fetch(SpawnerModelResource)
	
	m_spawnerModel.update(m_spawnerResource)
	m_spawnerModel.on_spawn.connect(on_spawn_received)

func update_tick(p_deltaTime: float):
	m_spawnerModel.update_tick(p_deltaTime)

func spawn(p_liveEnemies: LiveEnemiesModel):
	var random = Models.fetch(RandomModel)
	var index = random.range(m_spawnerResource.CreatureCount)
	var creature: CreatureModelResource = m_spawnerResource.get_creature(index)
	
	var model: EnemyModel = EnemyModel.new(creature)
	var view: EnemyView = kickstart(model, m_spawnerResource.EnemyViewScene, m_root)
	
	view.on_clicked.connect(on_clicked_received)
	model.on_knocked_out.connect(on_knocked_out_received)
	model.on_updated.connect(on_updated_received)
	
	p_liveEnemies.add_enemy(model)

# Signal implementations.
func on_spawn_received():
	var liveEnemies: LiveEnemiesModel = Models.fetch(LiveEnemiesModel)
	if liveEnemies.Count >= m_spawnerResource.MaximumLivingSpawns:
		return
	
	spawn(liveEnemies)

func on_updated_received(p_model: EnemyModel):
	if not Views.has_model(p_model):
		return
	
	var view = Views.get_view(p_model)
	view.update(p_model)

func on_clicked_received(p_view: EnemyView):
	if not Views.has_view(p_view):
		print(str("View: ", p_view, " not found in dictionary."))
		return
	
	var model = Views.get_key(p_view)
	model.target()

func on_knocked_out_received(p_model: EnemyModel):
	if not Views.has_model(p_model):
		print(str("No key found in dictionary for value: ", p_model))
		return
	
	p_model.on_updated.disconnect(on_updated_received)
	p_model.on_knocked_out.disconnect(on_knocked_out_received)
	var view = Views.get_view(p_model)
	view.terminate()
