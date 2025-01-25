class_name DashSkill
extends Skill

signal dash(float)

func _init():
	set_trigger_key("dash")
	set_bubble_cost(10)
	set_cooldown(1)

func use_skill():
	print("dashing")
	dash.emit(2)
