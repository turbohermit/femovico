class_name _CLASS_
extends AEffectController

func effect_type() -> Script: return YourEffect

func _init():
	register_effects()

func on_initialized():
	pass

func on_terminate():
	pass

func execute_effect(_p_card: ModelResourceCard, p_effect: AEffect):
	var yourEffect: YourEffect = p_effect as YourEffect
	# Execute logic
