class_name LiveEnemiesModel
extends AModel
func get_class_name(): return "LiveEnemiesModel"

var m_enemies: Array[EnemyModel]

signal on_enemy_added(p_model: EnemyModel)

var Count: int:
	get:
		return m_enemies.size()

func add_enemy(p_model: EnemyModel):
	if m_enemies.has(p_model):
		return
	
	m_enemies.append(p_model)
	on_enemy_added.emit(p_model)

func remove_enemy(p_model: EnemyModel):
	if not m_enemies.has(p_model):
		return
	
	m_enemies.erase(p_model)
