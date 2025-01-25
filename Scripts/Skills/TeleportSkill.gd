class_name TeleportSkill
extends Skill

func _ready():
	player = Game.player_movement as PlayerMovement

func _init():
	set_trigger_key("teleport")
	set_bubble_cost(20)
	set_cooldown(3)

func use_skill():
	var mouse_pos = player.get_global_mouse_position()
	for bubble in Game.teleport_bubbles:
		if bubble != null:
			var area2d = bubble.get_node("CollisionShape2D").get_node("Area2D")
			if mouse_pos.distance_to(area2d.global_position) < area2d.get_node("CollisionShape2D").shape.radius:
				player.global_position = mouse_pos
				print("teleport bubble countL: ", Game.teleport_bubbles.size())
				print("teleport")
				break
