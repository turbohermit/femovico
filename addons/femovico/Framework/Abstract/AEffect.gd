## ModelResource that handles card effects.
## Inherit from AEffect for serialized gameplay effect data.
class_name AEffect
extends AModelResource

signal on_activated(p_effect: AEffect)

func activate():
	on_activated.emit(self)
