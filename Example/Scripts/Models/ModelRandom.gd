class_name ModelRandom
extends AModel

# Private
var m_generator: RandomNumberGenerator

func _init():
	m_generator = RandomNumberGenerator.new()

func range(p_maximum: int):
	return m_generator.randi_range(0, p_maximum - 1)

func range_2D(p_range: int):
	return Vector2(m_generator.randf_range(-p_range, p_range), m_generator.randf_range(-p_range, p_range))
