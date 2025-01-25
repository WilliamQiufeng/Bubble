class_name Bubble
extends RigidBody2D

@export var damage: float = 20
@onready var controller: BubbleController = $CollisionShape2D/Area2D
