class_name HealthController
extends AController
func get_class_name(): return "HealthController"

var m_liveEnemiesModel: LiveEnemiesModel

func _init(p_liveEnemiesModel: LiveEnemiesModel):
	m_liveEnemiesModel = p_liveEnemiesModel
	p_liveEnemiesModel.on_enemy_added.connect(on_enemy_added)

func on_enemy_added(p_model: EnemyModel):
	p_model.on_targeted.connect(on_targeted_received)

func on_targeted_received(p_model: EnemyModel):
	p_model.take_damage(1)
