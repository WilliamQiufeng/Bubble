class_name AntiBubbleEffectController
extends BubbleEffectController

@export var damage: float = 10

# Override properties
func _get_effect_type() -> Constants.EffectType:
	return Constants.EffectType.ANTI

func get_bubble_color() -> Color:
	return Color(1, 0.5, 0.5)
func set_bubble_appearance():
	sprite.modulate *= get_bubble_color()

func _ready() -> void:
	super._ready()

# Handle player entering the bubble
func _handle_player_enter(player_movement: PlayerMovement) -> void:
	player_movement.player.hp -= damage
	bubble_controller.bubble.queue_free()
	pass

# Handle player exiting the bubble
func _handle_player_exit(player_movement: PlayerMovement) -> void:
	pass
