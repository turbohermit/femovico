class_name EnemyModel
extends AModel
func get_class_name(): return "EnemyModel"

# It's good practice for Models to have strict public and private accessors.
# This is to prevent Views or Controllers from manipulating data outside of their responsibility.
var m_position: Vector2
var m_health: int
var m_maxHealth: int
var m_speed: float

# Typically Views should only Get data from Models, and never set any,
var NormalizedHealth:
	get:
		return (1 / m_maxHealth) * m_health

var Position:
	get:
		return m_position

signal on_updated(p_model: EnemyModel)
signal on_knocked_out(p_model: EnemyModel)

func _init(p_resource: CreatureModelResource):
	m_health = p_resource.Health
	m_maxHealth = m_health
	m_speed = p_resource.Speed

# Typically Controllers should only call functions on Models.
# The Model will then manipulate its own data accordingly.
func take_damage(p_amount: int):
	m_health -= p_amount
	on_updated.emit(self)
	
	if m_health <= 0:
		on_knocked_out.emit(self)
	
