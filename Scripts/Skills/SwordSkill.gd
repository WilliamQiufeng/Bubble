class_name SwordSkill
extends Skill


func _ready():
	player = Game.player_movement as PlayerMovement

func _init():
	set_trigger_key(&"sword")
	set_bubble_cost(10)
	set_cooldown(2)

func use_skill():
	print("using sword")
	detect_attack()

func detect_attack():
	for i in range(attack_range.get_collision_count()):
		var body: Node2D = attack_range.get_collider(i)
		if not body.is_in_group(&"Player"):
			continue
		Game.player.hp -= attack_damage
