# FeatureInitializer is a class that automatically creates instances of the assigned startup Features.
# Place this node in your startup scene to easily create your wanted Features.
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

# Called every frame. p_delta is the elapsed time since the previous frame.
# This calls update_tick on Features > Controllers > Views.
# Can be removed if you want your game to update on a different timescale.
func _process(p_delta):
	# If you want to implement custom game pausing behaviour, replace the following lines.
	if GameStateUtility.Paused:
		return
	
	for feature in m_features:
		feature.update_tick(p_delta)

# Loops through all StartupFeatures and initializes them.
func start_features():
	var root = get_tree().get_current_scene()
	for feature in StartupFeatures:
		var instance = feature.initialize(root)
		m_features.append(instance)

# Returns the first found feature with the input class name.
func get_feature(p_type: String) -> AFeature:
	for feature in m_features:
		if feature.get_class_name() == p_type:
			return feature
	return null

# Terminates all tracked Features.
func terminate_features():
	for feature in m_features:
		feature.terminate()
	m_features.clear()
