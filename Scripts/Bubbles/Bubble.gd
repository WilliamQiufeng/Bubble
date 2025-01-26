class_name Bubble
extends RigidBody2D

@export var damage: float = 20
@onready var controller: BubbleController = $CollisionShape2D/Area2D
@onready var bubble: Sprite2D = $CollisionShape2D/BackBufferCopy/Bubble
@onready var floater: Sprite2D = $CollisionShape2D/BackBufferCopy/Bubble/Floater
var sprite_path: String 

func _physics_process(delta):
	var collision = move_and_collide(linear_velocity * delta, true)
	if collision:
		linear_velocity = linear_velocity.bounce(collision.get_normal())
		
func _ready():
	bubble.texture = load(sprite_path) # both needed
	floater.texture = load(sprite_path)
func change_sprite(path: String):
	sprite_path = path
	
