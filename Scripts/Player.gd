@tool
class_name Player
extends Node

# Signals
signal player_death()
signal hp_change(old_value: float, new_value: float)
signal mana_change(old_value: float, new_value: float)

# Private variables
var _hp: float = 100
var _mana: float = 100

# Exported properties for HP and Mana with getters and setters
@export var hp: float:
	get:
		return _hp
	set(value):
		var old_value = _hp
		_hp = clamp(value, 0, max_hp)
		hp_change.emit(old_value / max_hp, _hp / max_hp)
		if _hp <= 0:
			player_death.emit()

@export var mana: float:
	get:
		return _mana
	set(value):
		var old_value = _mana
		_mana = clamp(value, 0, max_mana)
		mana_change.emit(old_value / max_mana, _mana / max_mana)

# Properties for max HP, max Mana, and regeneration rates
var max_hp: int = 100
var max_mana: int = 100
var mana_regen_rate: float = 3
var hp_regen_rate: float = 1

# Called when the node is ready
func _ready() -> void:
	# Initialize HP and Mana to max values
	hp = max_hp
	mana = max_mana

# Physics process for regeneration
func _physics_process(delta: float) -> void:
	hp += hp_regen_rate * delta / Game.game_speed
	mana += mana_regen_rate * delta / Game.game_speed
