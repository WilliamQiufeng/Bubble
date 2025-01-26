class_name Skill
extends Node

var trigger_key: StringName = get_trigger_key()
var bubble_cost: float = get_bubble_cost()
var bubble: BubbleEffectController
@onready var cooldown: Timer = Timer.new()
var player: PlayerMovement:
	get: return Game.player_movement

func _ready():
	cooldown.one_shot = true
	cooldown.wait_time = get_cooldown()
	add_child(cooldown)

func get_trigger_key() -> StringName:
	return &"none"

func get_bubble_cost() -> float:
	return 0

func get_cooldown() -> float:
	return 1

# Calls use skill whenever the trigger key is pressed
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed(trigger_key):
		print("cooldown is ", cooldown.time_left)
		if cooldown.is_stopped():
			print("using skill from ", bubble)
			use_skill()
			cooldown.start()

func set_bubble(_bubble:BubbleEffectController) -> void:
	bubble =  _bubble

#abstract use skill function to be defined in each separate skill calss
func use_skill(): pass
