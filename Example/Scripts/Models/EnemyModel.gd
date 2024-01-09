class_name EnemyModel
extends AModel
func get_class_name(): return "EnemyModel"

# It's good practice for Models to have strict public and private accessors.
# This is to prevent Views or Controllers from manipulating data outside of their responsibility.
var m_position: Vector2
var m_origin: Vector2
var m_speed: float
var m_timeValue: float
var m_scale: float

var m_currentHealth: int
var m_maxHealth: int

# Typically Views should only Get data from Models, and never set any,
var NormalizedHealth:
	get:
		return (1.0 / m_maxHealth) * m_currentHealth

var Position:
	get:
		return m_position

var Origin:
	get:
		return m_origin

var Speed:
	get:
		return m_speed

var Scale:
	get:
		return m_scale

signal on_updated(p_model: EnemyModel)
signal on_targeted(p_model: EnemyModel)
signal on_knocked_out(p_model: EnemyModel)

func _init(p_resource: CreatureModelResource):
	m_currentHealth = p_resource.Health
	m_maxHealth = p_resource.Health
	m_speed = p_resource.Speed
	m_scale = p_resource.Scale

# Typically Controllers should only call functions on Models.
# The Model will then manipulate its own data accordingly.
func take_damage(p_amount: int):
	m_currentHealth -= p_amount
	on_updated.emit(self)
	
	if m_currentHealth <= 0:
		on_knocked_out.emit(self)

func target():
	on_targeted.emit(self)

func move(p_deltaTime: float):
	m_timeValue += m_speed * p_deltaTime
	m_position = m_origin + (Vector2(sin(m_timeValue), cos(m_timeValue)) * 100)
	on_updated.emit(self)

func set_origin(p_point: Vector2):
	m_position = p_point
	m_origin = p_point
	on_updated.emit(self)
