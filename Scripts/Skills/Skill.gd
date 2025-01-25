class_name Skill
extends Node

var trigger_key: String = "dash"
var bubble_cost: float = 10
var bubble: BubbleEffectController
var cooldown: Timer = Timer.new()
var player: Node

func set_trigger_key(key:String):
	trigger_key = key

func set_bubble_cost(cost:float):
	bubble_cost = cost

func set_cooldown(cd:float):
	cooldown.one_shot = true
	cooldown.wait_time = cd
	add_child(cooldown)

# Calls use skill whenever the trigger key is pressed
func _physics_process(delta: float) -> void:
	
	if bubble == null:
		print("no bubbles")
		return
		
	if Input.is_action_just_pressed(trigger_key):
		print("cooldown is ", cooldown.time_left)
		if cooldown.time_left <= 0:
			if bubble.mana > bubble_cost:
				print("using skill from ", bubble)
				use_skill()
				cooldown.start()
			else:
				print("dash no mana")
		else:
			print("dash in cd")

func set_bubble(_bubble:BubbleEffectController) -> void:
	bubble =  _bubble

#abstract use skill function to be defined in each separate skill calss
func use_skill(): pass
