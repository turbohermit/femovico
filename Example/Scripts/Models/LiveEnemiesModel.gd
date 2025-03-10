class_name LiveEnemiesModel
extends AModel

var m_enemies: Array[EnemyModel]

var Enemies: Array[EnemyModel]:
	get:
		return m_enemies

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
