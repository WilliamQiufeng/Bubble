class_name Enemy
extends CharacterBody2D

@export var animation_movement: AnimationMovement
@onready var target_tracker = $TargetTracker
@export var speed = 40
@export var hp = 100
@onready var hp_bar = $AnimatedSprite2D/HpBar
@onready var navigation_agent = $NavigationAgent2D
var is_dead = false

func _ready():
	hp_bar.max_value = hp
	hp_bar.value = hp

func _die():
	if is_dead:
		return
	print("Die")
	is_dead = true
	velocity = Vector2.ZERO
	animation_movement.die()
	animation_movement.sprite.animation_finished.connect(queue_free)

func _get_damage(amount: float):
	hp -= amount
	hp_bar.value = max(0, hp)
	if hp <= 0:
		_die()
	

func _is_attacking():
	return animation_movement.is_attacking()

func _physics_process(delta):
	move_and_slide()

func move(dir: Vector2):
	if is_dead:
		return
	var anim_str : StringName
	var dir_unit = dir.normalized()
	if dir == Vector2.ZERO:
		animation_movement.idle()
		velocity = Vector2.ZERO
	elif not _is_attacking():
		animation_movement.set_dir(dir_unit)
		animation_movement.move()
		velocity = dir_unit * speed
	else:
		velocity = Vector2.ZERO
