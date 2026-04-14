class_name ContCamera
extends AController

# Model Resources
var m_cameraConfig: MRCameraConfig

# Virtual implementations.
func on_models():
	m_cameraConfig = Models.fetch(MRCameraConfig)

func on_initialized():
	kickstart(self, m_cameraConfig.CameraViewScene)
