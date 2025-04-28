class_name ContMovement
extends AController

# Models
var m_liveEnemiesModel: ModelLiveEnemies

# Virtual implementations.
func on_models():
	m_liveEnemiesModel = Models.fetch(ModelLiveEnemies)
	m_liveEnemiesModel.on_enemy_added.connect(on_enemy_added)

func update_tick(p_deltaTime: float):
	for enemy in m_liveEnemiesModel.Enemies:
		enemy.move(p_deltaTime)

# Signal implmentations.
func on_enemy_added(p_model: ModelEnemy):
	var spawnerResource: SpawnerModelResource = Models.fetch(SpawnerModelResource)
	var random = Models.fetch(ModelRandom)
	var point: Vector2 = random.range_2D(spawnerResource.MaximumRange)
	p_model.set_origin(point)
