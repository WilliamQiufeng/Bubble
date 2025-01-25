extends Node2D
@export var melee_hit_anim: StringName = &"hit_melee_{type}"
@onready var swing_timer: Timer = $SwingTimer
@onready var player_movement = $".."
@onready var animation_movement = $"../AnimationMovement"
@onready var attack_range = $"../InteractionRayCast/AttackRange"
@export var damage: float = 50
@onready var sprite = $Sprite

func melee():
	if animation_movement.is_attacking() or not swing_timer.is_stopped():
		return
	animation_movement.play(melee_hit_anim)
	swing_timer.start()

func orientate_sword(cur_state: AnimationMovement.AnimationCommand):
	var new_scale = Vector2.ONE
	if cur_state.dir_str == &"away":
		new_scale.y = -1
		new_scale.x = -1
	scale = new_scale
	

func deal_damage():
	var count = attack_range.get_collision_count()
	for i in range(count):
		var collider = attack_range.get_collider(i)
		if collider is not Enemy:
			continue
		var enemy: Enemy = collider as Enemy
		enemy._get_damage(damage)
