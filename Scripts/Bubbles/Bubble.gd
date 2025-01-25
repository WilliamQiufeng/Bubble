class_name Bubble
extends RigidBody2D

@export var damage: float = 20
@onready var controller: BubbleController = $CollisionShape2D/Area2D

func _physics_process(delta):
	var collision = move_and_collide(linear_velocity * delta, true)
	if collision:
		linear_velocity = linear_velocity.bounce(collision.get_normal())
