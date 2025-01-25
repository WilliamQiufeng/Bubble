class_name DashBubbleEffectController
extends BubbleEffectController

var dash_skill: DashSkill

func get_texture_path() -> String:
	return "res://Scripts/Bubbles/Sprites/BubbleMovement.png"
	
# Override properties
func _get_effect_type() -> Constants.EffectType:
	return Constants.EffectType.DASH

func get_bubble_color() -> Color:
	return Color.from_hsv(60 / 360.0, 90 / 100.0, 1)

func _ready() -> void:
	super._ready()
	dash_skill = DashSkill.new()
	dash_skill.set_bubble(self)
	print("dash skill")

# Handle player entering the bubble
func _handle_player_enter(player_movement: PlayerMovement) -> void:
	print("giving dash skill")
	player_movement.add_child(dash_skill)

# Handle player exiting the bubble
func _handle_player_exit(player_movement: PlayerMovement) -> void:
	print("removing dash skill")
	player_movement.remove_child(dash_skill)
