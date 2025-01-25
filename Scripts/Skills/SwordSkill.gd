class_name SwordSkill
extends Skill

var attack_range
var damage: float = 10
var attack_animation: AnimationPlayer

func _ready():
	player = Game.player_movement
	attack_range = Game.attack_range
	attack_animation = attack_range.get_child(1)
	connect(attack_range.area_entered.get_name(), hit)

func _init():
	set_trigger_key("sword")
	set_bubble_cost(10)
	set_cooldown(2)

func use_skill():
	print("using sword ", "\n", "\n", "\n", "\n", "\n", "\n", "\n", "\n", "\n")
	#move sword
	attack_range.get_child(0).global_position = player.get_position() + player.idle_direction*0.2
	
	attack_animation.play("Attack")

func hit(area:Area2D):
	if area.is_in_group("Enemy"):
		print("hit enemy")
	else:
		print("Not enemy hit")
	
