extends CharacterBody2D

@export var sprite : AnimatedSprite2D

func _physics_process(delta):
	move_and_slide()

func move(speed):
	velocity = speed
