class_name SpawnController
extends AController
func get_class_name(): return "SpawnController"

# Models
var m_spawnerResource: SpawnerModelResource
var m_spawnerModel: SpawnerModel
var m_liveEnemiesModel: LiveEnemiesModel

# View Scene
var m_enemySceneView: PackedScene

var m_viewToModel = {}

func _init(p_spawnerResource: SpawnerModelResource, p_liveEnemiesModel: LiveEnemiesModel, p_enemySceneView: PackedScene):
	p_enemySceneView = m_enemySceneView
	m_liveEnemiesModel = p_liveEnemiesModel
	m_spawnerResource = p_spawnerResource
	
	m_spawnerModel = SpawnerModel.new(p_spawnerResource)
	m_spawnerResource.on_spawn.connect(on_spawn_received)

func update_tick(p_deltaTime: float):
	m_spawnerModel.update_tick(p_deltaTime)

func on_spawn_received():
	var index = m_spawnerModel.pick_creature_index()
	var creature: CreatureModelResource = m_spawnerResource.get_creature(index)
	
	var model: EnemyModel = EnemyModel.new(creature)
	var view: EnemyView = m_viewCollection.kickstart_view_scene(m_enemySceneView, m_root)
	view.on_clicked.connect(on_clicked_received)
	model.on_knocked_out.connect(on_knocked_out_received)
	model.on_updated.connect(on_updated_received)
	
	m_liveEnemiesModel.add_enemy(model)

func on_updated_received(p_model: EnemyModel):
	var view = m_viewToModel.find_key(p_model)
	if view == null:
		print(str("No key found in dictionary for value ", p_model))
		return
	
	view.update(p_model)

func on_clicked_received(p_view: EnemyView):
	if not m_viewToModel.has(p_view):
		print(str("View: ", p_view, " not found in dictionary."))
		return
	m_viewToModel[p_view].target()

func on_knocked_out_received(p_model: EnemyModel):
	var view = m_viewToModel.find_key(p_model)
	if view == null:
		print(str("No key found in dictionary for value ", p_model))
		return
	
	m_viewToModel.erase(view)
	view.terminate()
