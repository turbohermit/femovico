class_name EnemyView
extends AView

# If you want to use any Godot nodes, do so in Views.
# Good pratice is to have a View as parent, and assign any nodes it uses in the View script.
@export_category("References")
@export var Visual: Sprite2D
@export var ClickableArea: Area2D

@export_category("Visuals")
@export var HealthGradient: Gradient

signal on_clicked(p_view: EnemyView)

var m_hoovering: bool

func _ready():
	ClickableArea.mouse_entered.connect(area_entered_received)
	ClickableArea.mouse_exited.connect(area_exited_received)

func update(p_model: ModelEnemy):
	Visual.modulate = HealthGradient.sample(p_model.NormalizedHealth)
	Visual.position = p_model.Position
	Visual.scale = Vector2(p_model.Scale, p_model.Scale)

func _input(p_event):
	if p_event is InputEventMouseButton and p_event.pressed and p_event.button_index == MOUSE_BUTTON_LEFT and m_hoovering:
		clicked()

func clicked():
	var tween = get_tree().create_tween()
	tween.tween_property(Visual, "scale", Vector2.ONE * 0.8, 0.03)
	
	on_clicked.emit(self)

func area_entered_received():
	m_hoovering = true

func area_exited_received():
	m_hoovering = false
