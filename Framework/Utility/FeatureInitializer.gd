class_name FeatureInitializer
extends Node

@export var StartupFeatures: Array[AFeature]
@export var FollowUpScene: PackedScene

var m_features: Array[AFeature]

func _ready():
	start_features()
	if(FollowUpScene == null):
		return
	var scene = FollowUpScene.instantiate()
	add_child(scene)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed ("ui_text_backspace"):
		terminate_features()
		start_features()
	
	if(GameStateUtility.Paused):
		return
	for feature in m_features:
		feature.update_tick(delta)

func start_features():
	var root = get_tree().get_current_scene()
	for feature in StartupFeatures:
		var instance = feature.initialize(root, true, self)
		m_features.append(instance)

func get_feature(p_type: String) -> AFeature:
	for feature in m_features:
		if feature.get_class_name() == p_type:
			return feature
	return null

func terminate_features():
	for feature in m_features:
		feature.terminate()
	m_features.clear()
