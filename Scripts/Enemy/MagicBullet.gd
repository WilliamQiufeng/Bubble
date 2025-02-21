extends Attack

@onready var animation_movement: AnimationMovement = $"../AnimationMovement"
@export var hit_anim = "hit_anti_{type}"
@onready var character = $".."
@onready var bubble_scene: PackedScene = preload("res://bubble.tscn")
@onready var bullet_container = $"../../../Bubbles"
@onready var charge_timer = $ChargeTimer

func release_bubble():
	var factory = BubbleFactory.new()\
		.add_effect(Constants.EffectType.ANTI)\
		.make_bullet(Constants.BulletType.TINY, character.global_position, Game.player_movement.global_position)
	var bubble = bubble_scene.instantiate()
	factory.apply(bubble)
	bullet_container.add_child(bubble)

func attack():
	if animation_movement.is_attacking():
		return
	var dp: Vector2 = Game.player_movement.global_position - character.global_position
	var angle = dp.angle_to(Vector2.RIGHT)
	animation_movement.set_dir(dp.normalized())
	animation_movement.play(hit_anim)
	charge_timer.start()
