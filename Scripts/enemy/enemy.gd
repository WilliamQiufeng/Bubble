extends CharacterBody2D

@export var animation_movement: AnimationMovement
@onready var target_tracker = $TargetTracker
@export var speed = 40
@onready var attack_range = $TargetTracker/AttackRange
@export var attack_damage = 10
@export var hit_anim = "hit_{type}"
@onready var melee_timer = $MeleeTimer

func _physics_process(delta):
	move_and_slide()

func move(dir: Vector2):
	var anim_str : StringName
	var dir_unit = dir.normalized()
	if dir == Vector2.ZERO:
		animation_movement.idle()
	else:
		animation_movement.set_dir(dir_unit)
		animation_movement.move()
	velocity = dir_unit * speed

func detect_attack():
	for i in range(attack_range.get_collision_count()):
		var body: Node2D = attack_range.get_collider(i)
		if not body.is_in_group(&"Player"):
			continue
		Game.player.hp -= attack_damage

func attack():
	var dp: Vector2 = Game.player_movement.global_position - global_position
	var angle = dp.angle_to(Vector2.RIGHT)
	animation_movement.set_dir(dp.normalized())
	animation_movement.play(hit_anim)
	melee_timer.start()
