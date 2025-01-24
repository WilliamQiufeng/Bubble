class_name DashBubbleEffectController
extends BubbleEffectController

# Override properties
func _get_effect_type() -> Constants.EffectType:
	return Constants.EffectType.DASH

func get_bubble_color() -> Color:
	return Color.from_hsv(60 / 360.0, 90 / 100.0, 1)

func _ready() -> void:
	super._ready()

# Handle player entering the bubble
func _handle_player_enter(player_movement: PlayerMovement) -> void:
	player_movement.can_dash = true

# Handle player exiting the bubble
func _handle_player_exit(player_movement: PlayerMovement) -> void:
	player_movement.can_dash = false
