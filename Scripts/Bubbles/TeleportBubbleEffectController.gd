class_name TeleportBubbleEffectController
extends BubbleEffectController

var teleport_skill:TeleportSkill

func get_texture_path() -> String:
	var rand_index: int = randi_range(1, 7)
	return "res://Scripts/Bubbles/Sprites/BubbleTp" + str(rand_index) + ".png"

# Override properties
func _get_effect_type() -> Constants.EffectType:
	return Constants.EffectType.TELEPORT

func get_bubble_color() -> Color:
	return Color.from_hsv(120 / 12.0, 140 / 100.0, 1)

func _ready() -> void:
	super._ready()
	teleport_skill = TeleportSkill.new()
	teleport_skill.set_bubble(self)
	print("teleport skill")

# Handle player entering the bubble
func _handle_player_enter(player_movement: PlayerMovement) -> void:
	print("giving dash skill")
	player_movement.owner.add_child(teleport_skill)

# Handle player exiting the bubble
func _handle_player_exit(player_movement: PlayerMovement) -> void:
	print("removing dash skill")
	player_movement.owner.remove_child(teleport_skill)
