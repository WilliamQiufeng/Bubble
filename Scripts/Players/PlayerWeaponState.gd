@tool
class_name PlayerWeaponState
extends Node

# Reference to the player
var player: Player

# Current selected types
var current_bullet_type: Constants.BulletType
var current_effect_type: Constants.EffectType

# Available bullet and effect types
var available_bullet_types : Array[Constants.BulletType]= [Constants.BulletType.TINY, Constants.BulletType.SUPPLEMENT]
var available_effect_types : Array[Constants.EffectType]= [Constants.EffectType.THE_WORLD, Constants.EffectType.SWORD, Constants.EffectType.DASH]

func bullet_type_at(index: int):
	return available_bullet_types[index]

func effect_type_at(index: int):
	return available_effect_types[index]
	
func change_effect_type(index: int, effect_type: Constants.EffectType):
	available_effect_types[index] = effect_type
	effect_type_change.emit(index, effect_type)

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
		active_effect_type_change.emit(selected_effect_type_index, current_effect_type)
		print("Selected Effect Type =", str(current_effect_type))

signal effect_type_change(index: int, type: Constants.EffectType)
signal active_effect_type_change(index: int, type: Constants.EffectType)

# Called when the node is ready
func _ready() -> void:
	player = $"../PlayerController"
	selected_bullet_type_index = 0
	selected_effect_type_index = 0
