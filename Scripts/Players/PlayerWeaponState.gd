@tool
class_name PlayerWeaponState
extends Node

# Reference to the player
var player: Player

# Current selected types
var current_bullet_type: Constants.BulletType
var current_effect_type: Constants.EffectType

# Available bullet and effect types
var available_bullet_types := [Constants.BulletType.TINY, Constants.BulletType.SUPPLEMENT]
var available_effect_types := [Constants.EffectType.THE_WORLD, Constants.EffectType.FAST, Constants.EffectType.TELEPORT]

# Selected indices for bullet and effect types
var _selected_bullet_type_index: int = 0
var _selected_effect_type_index: int = 0

# Selected bullet type index with setter and getter
var selected_bullet_type_index: int:
	get:
		return _selected_bullet_type_index
	set(value):
		while value < 0:
			value += available_bullet_types.size()
		_selected_bullet_type_index = value % available_bullet_types.size()
		current_bullet_type = available_bullet_types[_selected_bullet_type_index]
		print("Selected Bullet Type =", str(current_bullet_type))

# Selected effect type index with setter and getter
var selected_effect_type_index: int:
	get:
		return _selected_effect_type_index
	set(value):
		while value < 0:
			value += available_effect_types.size()
		_selected_effect_type_index = value % available_effect_types.size()
		current_effect_type = available_effect_types[_selected_effect_type_index]
		print("Selected Effect Type =", str(current_effect_type))

# Called when the node is ready
func _ready() -> void:
	player = $"../PlayerController"
	selected_bullet_type_index = 0
	selected_effect_type_index = 0
