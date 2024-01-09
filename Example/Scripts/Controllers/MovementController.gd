class_name MovementController
extends AController
func get_class_name(): return "MovementController"

var m_spawnerModelResource: SpawnerModelResource
var m_randomModel: RandomModel
var m_liveEnemiesModel: LiveEnemiesModel

func _init(p_liveEnemiesModel: LiveEnemiesModel, p_randomModel: RandomModel, p_spawnerModelResource: SpawnerModelResource):
	m_spawnerModelResource = p_spawnerModelResource
	m_liveEnemiesModel = p_liveEnemiesModel
	m_randomModel = p_randomModel
	p_liveEnemiesModel.on_enemy_added.connect(on_enemy_added)

func update_tick(p_deltaTime: float):
	for enemy in m_liveEnemiesModel.Enemies:
		enemy.move(p_deltaTime)

func on_enemy_added(p_model: EnemyModel):
	var point: Vector2 = m_randomModel.range_2D(m_spawnerModelResource.MaximumRange)
	p_model.set_origin(point)
