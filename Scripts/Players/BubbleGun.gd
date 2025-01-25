extends Node2D

@onready var shooting_timer: Timer = $ShootingTimer
@onready var bubble_scene: PackedScene = preload("res://bubble.tscn")
@onready var player_weapon_state: Node = $"../PlayerWeaponState"
@export var bullet_container: Node2D

func _input(event: InputEvent):
	if event.is_action_pressed("last_gun"):
		player_weapon_state.selected_bullet_type_index -= 1
	elif event.is_action_pressed("next_gun"):
		player_weapon_state.selected_bullet_type_index += 1
	
	if event.is_action_pressed("bubble_slot_1"):
		player_weapon_state.selected_effect_type_index = 0
	elif event.is_action_pressed("bubble_slot_2"):
		player_weapon_state.selected_effect_type_index = 1
	elif event.is_action_pressed("bubble_slot_3"):
		player_weapon_state.selected_effect_type_index = 2
	if event.is_action_pressed("click") and shooting_timer.is_stopped():
		if player_weapon_state.current_bullet_type != Constants.BulletType.SUPPLEMENT:
			fire()
		shooting_timer.one_shot = false
		shooting_timer.start()
	elif event.is_action_released("click"):
		shooting_timer.one_shot = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func fire() -> void:
	var target = get_global_mouse_position()
	print("current effect type: ", player_weapon_state.current_effect_type)
	var factory = BubbleFactory.new()\
		.originate_from_player(20)\
		.add_effect(player_weapon_state.current_effect_type)\
		.make_bullet(player_weapon_state.current_bullet_type, Game.player_movement.global_position, target)
	
	if Game.player.mana < factory.mana_cost:
		print("no mana to shoot bubbles")
		return
	
	var new_bullet = bubble_scene.instantiate()
	factory.apply(new_bullet)
	Game.player.mana -= factory.mana_cost
	bullet_container.add_child(new_bullet)
