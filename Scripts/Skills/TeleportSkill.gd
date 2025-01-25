class_name TeleportSkill
extends Skill

func get_trigger_key(): return &"teleport"
func get_bubble_cost(): return 20
func get_cooldown(): return 3

func use_skill():
	var mouse_pos = Game.player_movement.get_global_mouse_position()
	for bubble in Game.teleport_bubbles:
		if bubble != null:
			var area2d = bubble.controller
			if mouse_pos.distance_to(area2d.global_position) < area2d.get_node("CollisionShape2D").shape.radius:
				Game.player_movement.global_position = mouse_pos
				print("teleport bubble countL: ", Game.teleport_bubbles.size())
				print("teleport")
				break
