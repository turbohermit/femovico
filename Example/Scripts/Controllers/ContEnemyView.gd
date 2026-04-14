class_name ContEnemyView
extends AController

# ModelResources
var m_spawnerResource: MRSpawner

# Models
var m_liveEnemies: ModelLiveEnemies

# Virtual implementations.
func on_models():
	m_spawnerResource = Models.fetch(MRSpawner)
	m_liveEnemies = Models.fetch(ModelLiveEnemies)
	m_liveEnemies.on_enemy_added.connect(on_enemy_added)

# Signal implementations.
func on_updated_received(p_model: ModelEnemy):
	if not Views.has_model(p_model):
		return
	
	var view = Views.get_view(p_model)
	view.update(p_model)

func on_clicked_received(p_view: EnemyView):
	if not Views.has_view(p_view):
		print(str("View: ", p_view, " not found in dictionary."))
		return
	
	var model = Views.get_key(p_view)
	model.target()

func on_knocked_out_received(p_model: ModelEnemy):
	if not Views.has_model(p_model):
		print(str("No key found in dictionary for value: ", p_model))
		return
	
	p_model.on_updated.disconnect(on_updated_received)
	p_model.on_knocked_out.disconnect(on_knocked_out_received)
	var view = Views.get_view(p_model)
	view.terminate()

func on_enemy_added(p_model: ModelEnemy):
	if Views.has_key(p_model):
		return
	
	var view: EnemyView = kickstart(p_model, m_spawnerResource.EnemyViewScene, m_root)
	view.on_clicked.connect(on_clicked_received)
	p_model.on_knocked_out.connect(on_knocked_out_received)
	p_model.on_updated.connect(on_updated_received)
