class_name MovementController
extends AController
func get_class_name(): return "MovementController"

var generator: RandomNumberGenerator
var m_liveEnemiesModel: LiveEnemiesModel

func _init(p_liveEnemiesModel: LiveEnemiesModel):
	m_liveEnemiesModel = p_liveEnemiesModel
	p_liveEnemiesModel.on_enemy_added.connect(on_enemy_added)
	
	generator = RandomNumberGenerator.new()

func update_tick(p_deltaTime: float):
	for enemy in m_liveEnemiesModel.Enemies:
		enemy.move(p_deltaTime)

func on_enemy_added(p_model: EnemyModel):
	# TODO split to seperate model. Maybe Random base model?
	# Also maximum spawn range (in spawner model)
	var point = Vector2(generator.randf_range(-100, 100), generator.randf_range(-100, 100))
	p_model.set_origin(point)
