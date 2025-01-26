@tool
class_name BubbleEffectController
extends Node

# Abstract properties
var effect_type: Constants.EffectType:
	get: return _get_effect_type()
var mana:int: 
	get: return bubble_controller.get_area()

@onready var bubble_controller: BubbleController
@onready var sprite: Sprite2D = $"../CollisionShape2D/BackBufferCopy/Bubble"

# Abstract methods (to be implemented by subclasses)
func _handle_player_enter(player_movement: PlayerMovement) -> void: pass
func _handle_player_exit(player_movement: PlayerMovement) -> void: pass
func _handle_enemy_enter(enemy: Enemy) -> void: pass
func _handle_enemy_exit(enemy: Enemy) -> void: pass
func _get_effect_type() -> Constants.EffectType: return Constants.EffectType.NONE

func get_texture_path() -> String:
	return "res://Scripts/Bubbles/bubble.png"

# Optional bubble color
func get_bubble_color() -> Color:
	return Color.WHITE

func set_bubble_appearance():
	#sprite.modulate = get_bubble_color()
	#print("Color = ", sprite.modulate)
	pass
	

# Deferred body enters
var deferred_body_enters: Array = []

func _ready() -> void:
	set_bubble_appearance()

	bubble_controller = $"../CollisionShape2D/Area2D"
	bubble_controller.connect("body_entered", _on_body_entered)
	bubble_controller.connect("body_exited", _on_body_exited)

func _physics_process(delta: float) -> void:
	if not Constants.is_bullet(effect_type) and deferred_body_enters.size() > 0:
		for deferred_body in deferred_body_enters:
			_on_body_entered(deferred_body)
		deferred_body_enters.clear()

func _on_body_entered(node: Node2D) -> void:
	if Constants.is_bullet(effect_type):
		deferred_body_enters.append(node)
		return

	if node is PlayerMovement:
		#print("Enter ", node)
		_handle_player_enter(node)
	if node is Enemy:
		_handle_enemy_enter(node)

func _on_body_exited(node: Node2D) -> void:
	if Constants.is_bullet(effect_type):
		deferred_body_enters.erase(node)
		return

	if node is PlayerMovement:
		#print("Exit ", node)
		_handle_player_exit(node)
	if node is Enemy:
		_handle_enemy_exit(node)
