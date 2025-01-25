class_name SwordBubbleEffectController
extends BubbleEffectController

var sword_skill:SwordSkill

# Override properties
func _get_effect_type() -> Constants.EffectType:
	return Constants.EffectType.DASH

func get_bubble_color() -> Color:
	return Color.from_hsv(346.0 / 360.0, 100.0 / 100.0, 1)

func _ready() -> void:
	super._ready()
	sword_skill = SwordSkill.new()
	sword_skill.set_bubble(self)

# Handle player entering the bubble
func _handle_player_enter(player_movement: PlayerMovement) -> void:
	player_movement.sword.visible = true
	player_movement.owner.add_child(sword_skill)

# Handle player exiting the bubble
func _handle_player_exit(player_movement: PlayerMovement) -> void:
	player_movement.sword.visible = false
	player_movement.owner.remove_child(sword_skill)
