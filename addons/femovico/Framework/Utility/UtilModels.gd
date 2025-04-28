# Global utility for now just used to easily fetch the ModelCollection for AFeatures.
extends Node

# "Private"
var m_modelCollection: ModelCollection

func get_collection() -> ModelCollection:
	if m_modelCollection == null:
		m_modelCollection = ModelCollection.new()
	
	return m_modelCollection
