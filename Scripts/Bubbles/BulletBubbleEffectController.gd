class_name BulletBubbleEffectController
extends BubbleEffectController

func _get_effect_type():
	return Constants.EffectType.BULLET

var collision_shape_2d: CollisionShape2D

func set_bubble_appearance():
	pass

func _ready() -> void:
	super._ready()
	collision_shape_2d = $"../CollisionShape2D"
	collision_shape_2d.apply_scale(Vector2.ONE * 0.2)

	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = 5
	timer.one_shot = true
	timer.timeout.connect(get_parent().queue_free)
	timer.start()

# Handle player entering the bubble
func _handle_player_enter(player_movement: PlayerMovement) -> void:
	pass

# Handle player exiting the bubble
func _handle_player_exit(player_movement: PlayerMovement) -> void:
	pass
