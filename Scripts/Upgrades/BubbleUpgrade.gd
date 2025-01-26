class_name BubbleUpgrade
extends Upgrade

var bubble_effect_type: Constants.EffectType

func _init(path: String, effect_type: Constants.EffectType) -> void:
	texture_path = path
	bubble_effect_type = effect_type

func upgrade():
	Game.player.hp = max(Game.player.hp + 10, Game.player.max_hp)
	print("Health regenerated")
