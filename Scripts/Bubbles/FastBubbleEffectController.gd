class_name FastBubbleEffectController
extends BubbleEffectController

# Constants
const FAST_MULTIPLIER: float = 1.3

func get_texture_path() -> String:
	return "res://Scripts/Bubbles/Sprites/BubbleMovement.png"

# Override properties
func _get_effect_type() -> Constants.EffectType:
	return Constants.EffectType.FAST

func get_bubble_color() -> Color:
	return Color.from_hsv(279 / 360.0, 77 / 100.0, 1)

# Handle player entering the bubble
func _handle_player_enter(player_movement: PlayerMovement) -> void:
	player_movement.fast(FAST_MULTIPLIER)

# Handle player exiting the bubble
func _handle_player_exit(player_movement: PlayerMovement) -> void:
	player_movement.fast(1 / FAST_MULTIPLIER)
