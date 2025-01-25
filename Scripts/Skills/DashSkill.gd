class_name DashSkill
extends Skill

signal dash(float)

func _ready():
	player = Game.player_movement as PlayerMovement

func _init():
	set_trigger_key("dash")
	set_bubble_cost(10)
	set_cooldown(1)

func use_skill():
	print("dashing")
	player.dash_vector += player.idle_direction * player.speed * 2
