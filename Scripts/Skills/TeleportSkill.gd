class_name TeleportSkill
extends Skill

func _ready():
	player = Game.player_movement as PlayerMovement

func _init():
	set_trigger_key("teleport")
	set_bubble_cost(20)
	set_cooldown(3)

func use_skill():
	var mouse_pos = get_viewport().get_mouse_position()
	Game.player_movement.global_position = mouse_pos
	print("teleport")	
