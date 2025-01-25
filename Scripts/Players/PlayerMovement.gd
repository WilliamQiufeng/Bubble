class_name PlayerMovement
extends CharacterBody2D

@export var speed: float = 100
@export var bullet_container: Node2D

var idle_direction: Vector2 = Vector2.DOWN
@onready var bubble_scene: PackedScene = preload("res://bubble.tscn")
@onready var player_weapon_state: Node = $PlayerWeaponState
@onready var player: Node = $PlayerController
@onready var animation_movement : AnimationMovement = $AnimationMovement
var dash_vector: Vector2 = Vector2.ZERO
var shooting_timer: Timer
var can_dash: bool = false
var dashing_cooldown_timer: Timer

func _ready():
	shooting_timer = Timer.new()
	shooting_timer.wait_time = 0.2
	shooting_timer.connect("timeout", fire)
	add_child(shooting_timer)
	
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
	
	if Input.is_action_just_pressed("last_gun"):
		player_weapon_state.selected_bullet_type_index -= 1
	elif Input.is_action_just_pressed("next_gun"):
		player_weapon_state.selected_bullet_type_index += 1
	
	if Input.is_action_just_pressed("bubble_slot_1"):
		player_weapon_state.selected_effect_type_index = 0
	elif Input.is_action_just_pressed("bubble_slot_2"):
		player_weapon_state.selected_effect_type_index = 1
	elif Input.is_action_just_pressed("bubble_slot_3"):
		player_weapon_state.selected_effect_type_index = 2
	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		fire()
		shooting_timer.start()
	elif event.is_action_released("click"):
		shooting_timer.stop()

func fire() -> void:
	var target = get_global_mouse_position()
	var factory = BubbleFactory.new()\
		.add_effect(player_weapon_state.current_effect_type)\
		.make_bullet(player_weapon_state.current_bullet_type, position, target)
	
	if player.mana < factory.mana_cost:
		return
	
	var new_bullet = bubble_scene.instantiate()
	factory.apply(new_bullet)
	player.mana -= factory.mana_cost
	bullet_container.add_child(new_bullet)

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
