class_name HealthController
extends AController

func on_models():
	var liveEnemies: LiveEnemiesModel = Models.get_model(LiveEnemiesModel)
	liveEnemies.on_enemy_added.connect(on_enemy_added)

func on_enemy_added(p_model: EnemyModel):
	p_model.on_targeted.connect(on_targeted_received)

func on_targeted_received(p_model: EnemyModel):
	p_model.take_damage(1)
