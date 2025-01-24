extends Label

@export var limbo_hsm : BTPlayer:
	set(value):
		if limbo_hsm != null:
			limbo_hsm.active_state_changed.disconnect(_on_active_state_changed)
		limbo_hsm = value
		if limbo_hsm != null:
			var current_state = limbo_hsm.get_active_state()
			if current_state != null:
				text = current_state.name
			limbo_hsm.active_state_changed.connect(_on_active_state_changed)

func _on_active_state_changed(current: LimboState, previous: LimboState):
	text = current.name

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
