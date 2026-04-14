class_name RenderingFeature
extends AFeature

@export_category("Model Resources")
@export var CameraConfig: MRCameraConfig

# Virtual implementations.
func init_models():
	Models.kickstart_model_resource(CameraConfig)

func init_controllers():
	kickstart(ContCamera.new())
