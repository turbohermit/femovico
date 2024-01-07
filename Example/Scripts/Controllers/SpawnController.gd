class_name SpawnController
extends AController
func get_class_name(): return "SpawnController"

# Controllers should only cache references to Models, ModelResources and ViewScenes.
var m_spawnerResource: SpawnerModelResource
var m_spawnerModel: SpawnerModel
var m_enemySceneView: PackedScene

func _init(p_spawnerResource: SpawnerModelResource):
	m_spawnerModel = SpawnerModel.new(p_spawnerResource)
	
	m_spawnerResource = p_spawnerResource
	m_spawnerResource.on_spawn.connect(on_spawn_received)

func on_spawn_received():
	var index = m_spawnerModel.pick_creature_index()
	var creature: CreatureModelResource = m_spawnerResource.get_creature(index)
	
	var model: EnemyModel = EnemyModel.new(creature)
	var view: EnemyView = m_viewCollection.kickstart_view_scene(m_enemySceneView, m_root)
	

func update_tick(p_deltaTime: float):
	m_spawnerModel.update_tick(p_deltaTime)

func on_initialized():
	pass

func on_terminate():
	pass

