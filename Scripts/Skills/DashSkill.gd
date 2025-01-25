class_name DashSkill
extends Skill

func get_trigger_key(): return &"dash"
func get_bubble_cost(): return 10
func get_cooldown(): return 1

func use_skill():
	player.dash_vector += player.idle_direction * player.speed * 2
