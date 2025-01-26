class_name BubbleUpgrade
extends Upgrade

var bubble_effect_type: Constants.EffectType

func _init(path: String, effect_type: Constants.EffectType) -> void:
	texture_path = path
	bubble_effect_type = effect_type

func upgrade():
	window.generate_equiped_bubbles_selection(bubble_effect_type)
	display_bubble_selection()
	print("you chose a bubble upgrade")
	#destroy_window()
