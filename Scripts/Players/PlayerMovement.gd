class_name PlayerMovement
extends CharacterBody2D

@export var speed: float = 100
@export var bullet_container: Node2D

var idle_direction: Vector2 = Vector2.DOWN
@onready var player_weapon_state: Node = $PlayerWeaponState
@onready var player: Player = $PlayerController
@onready var animation_movement : AnimationMovement = $AnimationMovement
@onready var interaction_raycast = $InteractionRayCast
@onready var attack_range = $InteractionRayCast/AttackRange
@onready var sword = $Sword


var dash_vector: Vector2 = Vector2.ZERO
var is_dead: bool = false

func _ready():
	Sfx.affect(RefSfxTrail,{"target":$AnimatedSprite2D,"container":get_parent()}) # sample code to apply trail sfx
		   

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

func handle_death():
	is_dead = true
	animation_movement.die()

func _input(event: InputEvent) -> void:
	pass

func _physics_process(delta: float) -> void:
	if is_dead:
		return
	get_input()
	velocity += dash_vector
	move_and_slide()
	dash_vector = dash_vector.lerp(Vector2.ZERO, delta * 7)

func fast(multiplier: float) -> void:
	speed *= multiplier

signal interact(node: Node2D)
