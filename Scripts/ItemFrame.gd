extends TextureRect

@export var selected_texture: Texture2D
@export var unselected_texture: Texture2D
@export var slot_number: int = 0
@onready var slot_texture = $TextureRect
const BUBBLE_ICON_CLOCK = preload("res://Scripts/Bubbles/Sprites/Icons/BubbleIconClock.png")
const BUBBLE_ICON_MOVEMENT = preload("res://Scripts/Bubbles/Sprites/Icons/BubbleIconMovement.png")
const BUBBLE_ICON_SWORD = preload("res://Scripts/Bubbles/Sprites/Icons/BubbleIconSword.png")
const BUBBLE_ICON_TP = preload("res://Scripts/Bubbles/Sprites/Icons/BubbleIconTp.png")
# Called when the node enters the scene tree for the first time.
func _ready():
	Game.player_movement.player_weapon_state.effect_type_change.connect(_check_slot_change)
	Game.player_movement.player_weapon_state.active_effect_type_change.connect(_check)
	update_slot_texture()

func update_slot_texture():
	if Game.player_movement.player_weapon_state.selected_effect_type_index == slot_number:
		texture = selected_texture
	else:
		texture = unselected_texture
		
	match Game.player_movement.player_weapon_state.effect_type_at(slot_number):
		Constants.EffectType.THE_WORLD:
			slot_texture.texture = BUBBLE_ICON_CLOCK
		Constants.EffectType.SWORD:
			slot_texture.texture = BUBBLE_ICON_SWORD
		Constants.EffectType.FAST:
			slot_texture.texture = BUBBLE_ICON_MOVEMENT
		Constants.EffectType.TELEPORT:
			slot_texture.texture = BUBBLE_ICON_TP
func _check_slot_change(index: int, type: Constants.EffectType):
	if slot_number == index:
		texture = selected_texture
		update_slot_texture()
func _check(index: int, type: Constants.EffectType):
	update_slot_texture()
