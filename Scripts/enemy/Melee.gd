extends Attack


@onready var animation_movement: AnimationMovement = $"../AnimationMovement"
@onready var attack_range = $"../TargetTracker/AttackRange"
@export var attack_damage = 10
@export var hit_anim = "hit_melee_{type}"
@onready var melee_timer = $MeleeTimer
@onready var character = $".."
var _is_attacking = false

func detect_attack():
	for i in range(attack_range.get_collision_count()):
		var body: Node2D = attack_range.get_collider(i)
		if not body.is_in_group(&"Player"):
			continue
		Game.player.hp -= attack_damage

func attack():
	var dp: Vector2 = Game.player_movement.global_position - character.global_position
	var angle = dp.angle_to(Vector2.RIGHT)
	animation_movement.set_dir(dp.normalized())
	animation_movement.play(hit_anim)
	melee_timer.start()
