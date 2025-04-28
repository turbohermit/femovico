class_name ContHealth
extends AController

# Virtual implementations.
func on_models():
	var liveEnemies: ModelLiveEnemies = Models.fetch(ModelLiveEnemies)
	liveEnemies.on_enemy_added.connect(on_enemy_added)

# Signal implementations.
func on_enemy_added(p_model: ModelEnemy):
	p_model.on_targeted.connect(on_targeted_received)

func on_targeted_received(p_model: ModelEnemy):
	p_model.take_damage(1)
