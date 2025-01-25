class_name SwordSkill
extends Skill

var attack_range
var damage: float = 10

func _ready():
	attack_range = Game.attack_range

func _init():
	set_trigger_key("sword")
	set_bubble_cost(10)
	set_cooldown(2)

func use_skill():
	print("using sword ", "\n", "\n", "\n", "\n", "\n", "\n", "\n", "\n", "\n")
	detect_attack()

func detect_attack():
	print(attack_range.get_collision_count())
	for i in range(attack_range.get_collision_count()):
		var body: Node2D = attack_range.get_collider(i).get_parent()
		print(body)
		print("detecting enemies")
		if body is Enemy:
			print("enemy hit", "\n", "\n", "\n", "\n", "\n", "\n", "\n", "\n", "\n", "\n")
			body = body as Enemy
			#knockback and damage enemy
			body.knockback(body.position - Game.player.position, 10)
			body._get_damage(damage)
		else:
			print("non enemys hit")
