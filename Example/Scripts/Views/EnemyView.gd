class_name EnemyView
extends AView
func get_class_name(): return "EnemyView"

@export_category("References")
@export var Visual: Sprite2D

@export_category("Visuals")
@export var HealthGradient: Gradient

signal on_clicked(p_view: EnemyView)

func update(p_model: EnemyModel):
	Visual.modulate = HealthGradient.sample(p_model.NormalizedHealth)
	Visual.position = p_model.Position
	Visual.scale = Vector2(p_model.Scale, p_model.Scale)

# Not a very beautiful way to collect input, don't do this at home kids!
func _input(p_event):
	if p_event is InputEventMouseButton and p_event.pressed and p_event.button_index == MOUSE_BUTTON_LEFT:
		var rect = Visual.get_rect()
		var localPoint = Visual.to_local(p_event.position)
		if rect.has_point(localPoint):
			on_clicked.emit(self)
