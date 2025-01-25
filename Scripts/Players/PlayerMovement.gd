class_name PlayerMovement
extends CharacterBody2D

@export var speed: float = 100
@export var bullet_container: Node2D

var idle_direction: Vector2 = Vector2.DOWN
@onready var player_weapon_state: Node = $PlayerWeaponState
@onready var player: Player = $PlayerController
@onready var animation_movement : AnimationMovement = $AnimationMovement
@onready var interaction_raycast = $InteractionRayCast
var dash_vector: Vector2 = Vector2.ZERO
var can_dash: bool = false
var dashing_cooldown_timer: Timer

func _ready():
	dashing_cooldown_timer = Timer.new()
	dashing_cooldown_timer.wait_time = 0.8
	dashing_cooldown_timer.one_shot = true
	add_child(dashing_cooldown_timer)
	

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed
	
	if velocity != Vector2.ZERO:
		animation_movement.set_dir(velocity.normalized())
		animation_movement.move()
		idle_direction = velocity.normalized()
	else:
		animation_movement.idle()
	
	if Input.is_action_just_pressed("interact"):
		var collider = interaction_raycast.get_collider()
		print(collider)
		interact.emit(collider)
	

func _input(event: InputEvent) -> void:
	pass


func OnDash(mag: float):
	dash_vector += idle_direction * speed * mag

func _physics_process(delta: float) -> void:
	get_input()
	var collision = move_and_collide((velocity + dash_vector) * delta)
	if collision:
		velocity = velocity.slide(collision.get_normal())
	dash_vector = dash_vector.lerp(Vector2.ZERO, delta * 7)

func fast(multiplier: float) -> void:
	speed *= multiplier

signal interact(node: Node2D)
