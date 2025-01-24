@tool
extends Node

# Exported property for GameSpeed with setter and getter
@export var game_speed: float:
	get:
		return Engine.time_scale
	set(value):
		Engine.time_scale = value
		game_speed_change.emit(value)

# Signal for when the game speed changes
signal game_speed_change(new_speed: float)

# Method to control the game speed
func set_the_world(active: bool) -> void:
	game_speed = 1.0 if active else 0.5
