class_name MovementController
extends AController

# ModelResources
var m_spawnerModelResource: SpawnerModelResource

# Models
var m_liveEnemiesModel: LiveEnemiesModel

func _init(p_spawnerModelResource: SpawnerModelResource):
	m_spawnerModelResource = p_spawnerModelResource

func on_models():
	m_liveEnemiesModel = Models.get_model(LiveEnemiesModel)
	m_liveEnemiesModel.on_enemy_added.connect(on_enemy_added)

func update_tick(p_deltaTime: float):
	for enemy in m_liveEnemiesModel.Enemies:
		enemy.move(p_deltaTime)

func on_enemy_added(p_model: EnemyModel):
	var random = Models.get_model(RandomModel)
	var point: Vector2 = random.range_2D(m_spawnerModelResource.MaximumRange)
	p_model.set_origin(point)
