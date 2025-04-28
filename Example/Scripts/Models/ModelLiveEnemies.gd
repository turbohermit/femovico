class_name ModelLiveEnemies
extends AModel

# Accessors
var Enemies: Array[ModelEnemy]:
	get:
		return m_enemies
var Count: int:
	get:
		return m_enemies.size()

# Private
var m_enemies: Array[ModelEnemy]

# Signals
signal on_enemy_added(p_model: ModelEnemy)

func add_enemy(p_model: ModelEnemy):
	if m_enemies.has(p_model):
		return
	
	m_enemies.append(p_model)
	on_enemy_added.emit(p_model)

func remove_enemy(p_model: ModelEnemy):
	if not m_enemies.has(p_model):
		return
	
	m_enemies.erase(p_model)
