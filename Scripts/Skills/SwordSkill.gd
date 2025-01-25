class_name SwordSkill
extends Skill

var attack_range
var damage: float = 10
var attack_animation: AnimationPlayer

func _ready():
	player = Game.player_movement
	attack_range = Game.attack_range
	attack_animation = Game.player_movement.attack_animation
	connect(attack_range.area_entered.get_name(), hit)

func _init():
	set_trigger_key("sword")
	set_bubble_cost(10)
	set_cooldown(2)

func use_skill():
	print("using sword ", "\n", "\n", "\n", "\n", "\n", "\n", "\n", "\n", "\n")
	#moves sword to movement direction
	attack_range.get_node("CollisionShape2D").global_position = player.get_position() + player.idle_direction*10
	
	#plays attack animation
	attack_animation.play("Attack")

#detects enemy hit
func hit(area:Area2D):
	if area.is_in_group("Enemy"):
		print("hit enemy")
	else:
		print("Not enemy hit")
	
