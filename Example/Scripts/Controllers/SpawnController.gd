class_name SpawnController
extends AController

# Models
var m_spawnerResource: SpawnerModelResource
var m_spawnerModel: SpawnerModel
var m_liveEnemiesModel: LiveEnemiesModel
var m_randomModel: RandomModel

# View Scene
var m_enemySceneView: PackedScene

func _init(p_liveEnemiesModel: LiveEnemiesModel, p_randomModel: RandomModel, p_spawnerResource: SpawnerModelResource, p_enemySceneView: PackedScene):
	m_liveEnemiesModel = p_liveEnemiesModel
	m_randomModel = p_randomModel
	m_spawnerResource = p_spawnerResource
	m_enemySceneView = p_enemySceneView
	
	m_spawnerModel = SpawnerModel.new(p_spawnerResource)
	m_spawnerModel.on_spawn.connect(on_spawn_received)

func update_tick(p_deltaTime: float):
	m_spawnerModel.update_tick(p_deltaTime)

func on_spawn_received():
	if m_liveEnemiesModel.Count >= m_spawnerResource.MaximumLivingSpawns:
		return
	
	var index = m_randomModel.range(m_spawnerResource.CreatureCount)
	var creature: CreatureModelResource = m_spawnerResource.get_creature(index)
	
	var model: EnemyModel = EnemyModel.new(creature)
	var view: EnemyView = kickstart(model, m_enemySceneView, m_root)
	view.on_clicked.connect(on_clicked_received)
	model.on_knocked_out.connect(on_knocked_out_received)
	model.on_updated.connect(on_updated_received)
	
	m_liveEnemiesModel.add_enemy(model)

func on_updated_received(p_model: EnemyModel):
	if not m_viewCollection.has_model(p_model):
		return
	
	var view = m_viewCollection.get_view(p_model)
	view.update(p_model)

func on_clicked_received(p_view: EnemyView):
	if not m_viewCollection.has_view(p_view):
		print(str("View: ", p_view, " not found in dictionary."))
		return
	
	var model = m_viewCollection.get_key(p_view)
	model.target()

func on_knocked_out_received(p_model: EnemyModel):
	if not m_viewCollection.has_model(p_model):
		print(str("No key found in dictionary for value: ", p_model))
		return
	
	p_model.on_updated.disconnect(on_updated_received)
	p_model.on_knocked_out.disconnect(on_knocked_out_received)
	var view = m_viewCollection.get_view(p_model)
	view.terminate()
