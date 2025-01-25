class_name Weapon
extends Node

var weapon_name: String
var damage: float
var consumption: float
var weapon_type: Constants.WeaponType

func Fire() -> void:
	match weapon_type:
		Constants.WeaponType.MELEE:
			pass
		Constants.WeaponType.RANGE:
			pass
