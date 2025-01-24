class_name TheWorldBubbleEffectController
extends BubbleEffectController

# Constants
const GAME_SPEED_MULTIPLIER: float = 0.5

# Override properties
func _get_effect_type() -> Constants.EffectType:
	return Constants.EffectType.THE_WORLD

func get_bubble_color() -> Color:
	return Color.from_hsv(230 / 360.0, 90 / 100.0, 1)

# Handle player entering the bubble
func _handle_player_enter(player_movement: PlayerMovement) -> void:
	Game.game_speed *= GAME_SPEED_MULTIPLIER
	player_movement.fast(1 / GAME_SPEED_MULTIPLIER)

# Handle player exiting the bubble
func _handle_player_exit(player_movement: PlayerMovement) -> void:
	Game.game_speed /= GAME_SPEED_MULTIPLIER
	player_movement.fast(GAME_SPEED_MULTIPLIER)
