@tool
extends Node

var afterTutorial:bool = false
func _ready() -> void:
	afterTutorial = false
# Exported property for GameSpeed with setter and getter
@export var game_speed: float:
	get:
		return Engine.time_scale
	set(value):
		Engine.time_scale = value
		game_speed_change.emit(value)

# Signal for when the game speed changes
signal game_speed_change(new_speed: float)

func nodes_in_group(group_name: StringName) -> Array[Node]:
	return get_tree().get_nodes_in_group(group_name)

var player_movement: PlayerMovement:
	get: return nodes_in_group(&"Player")[0] as PlayerMovement

var teleport_bubbles: Array[Bubble] = []

var player: Player:
	get: return player_movement.player

var equiped_bubbles: Array[Constants.EffectType]:
	get: return player_movement.player_weapon_state.available_effect_types

var attack_range: ShapeCast2D:
	get: return player_movement.attack_range

# Method to control the game speed
func set_the_world(active: bool) -> void:
	game_speed = 1.0 if active else 0.5
