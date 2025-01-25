class_name SupplementBubbleEffectController
extends BubbleEffectController

# Constants
const SPEED: float = 100.0

# Properties
var target_position: Vector2
var timer: Timer = Timer.new()
var bubble: Bubble

# Override properties
func _get_effect_type() -> Constants.EffectType:
	return Constants.EffectType.BULLET

func set_bubble_appearance():
	pass

func _ready() -> void:
	super._ready()
	add_child(timer)
	bubble = get_parent() as Bubble
	timer.wait_time = 5.0
	timer.one_shot = true
	timer.timeout.connect(_target_reached)
	timer.start()

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	var dp = target_position - bubble.position
	if dp.length_squared() < 25:
		_target_reached()
		return

	bubble.linear_velocity = dp.normalized() * SPEED

func _handle_player_enter(player_movement: PlayerMovement) -> void:
	pass

func _handle_player_exit(player_movement: PlayerMovement) -> void:
	pass

func _target_reached() -> void:
	bubble.linear_velocity = Vector2.ZERO
	bubble.constant_force = Vector2.ZERO
	queue_free()
