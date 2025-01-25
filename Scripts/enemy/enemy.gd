class_name Enemy
extends CharacterBody2D

@export var animation_movement: AnimationMovement
@onready var target_tracker = $TargetTracker
@export var speed = 40

func _is_attacking():
	return animation_movement.is_attacking()

func _physics_process(delta):
	move_and_slide()

func knockback(dir:Vector2, mg:float):
	velocity += dir * mg

func move(dir: Vector2):
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
