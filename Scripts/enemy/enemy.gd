extends CharacterBody2D

@export var sprite : AnimatedSprite2D
@export var idle_anim = &"idle_{type}"
@export var move_anim = &"move_{type}"
@export var hit_anim = &"hit_{type}"
@onready var target_tracker = $TargetTracker
@export var speed = 40
@onready var attack_range = $AttackRange
@export var attack_damage = 10

var flip_h = false
var dir_str = "towards"

func _ready():
	sprite.play()

func _physics_process(delta):
	move_and_slide()
	
func find_dir_str(angle: float):
	while angle >= 2 * PI:
		angle -= 2 * PI
	while angle < 0:
		angle += 2 * PI
	var pi4 = PI / 4
	flip_h = false
	dir_str = "towards"
	if angle < pi4 or angle >= 7 * pi4:
		dir_str = "left"
		flip_h = true
	elif angle >= pi4 and angle < 3 * pi4:
		dir_str = "away"
	elif angle >= 3 * pi4 and angle < 5 * pi4:
		dir_str = "left"

func move(dir: Vector2):
	var anim_str : StringName
	var dir_unit = dir.normalized()
	if dir == Vector2.ZERO:
		anim_str = idle_anim.format({"type": dir_str})
	else:
		var angle = dir_unit.angle_to(Vector2.RIGHT)
		target_tracker.rotation = -dir_unit.angle_to(Vector2.DOWN)
		find_dir_str(angle)
		anim_str = move_anim.format({"type": dir_str})
	velocity = dir_unit * speed
	if sprite.is_playing() and sprite.animation.begins_with("hit"):
		return
	sprite.play(anim_str)
	sprite.flip_h = flip_h

func detect_attack():
	if not sprite.animation.begins_with("hit") or not sprite.frame == 2:
		return
	for i in range(attack_range.get_collision_count()):
		var body: Node2D = attack_range.get_collider(i)
		if not body.is_in_group(&"Player"):
			continue
		Game.player.hp -= attack_damage

func attack():
	var dp: Vector2 = Game.player_movement.global_position - global_position
	var angle = dp.angle_to(Vector2.RIGHT)
	find_dir_str(angle)
	var anim_str = hit_anim.format({"type": dir_str})
	sprite.play(anim_str)
	sprite.flip_h = flip_h
