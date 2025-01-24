extends BTAction

@export var tolerance: float = 200

@export var target: Vector2

func _tick(delta):
	if not agent.target_tracker.player_spotted:
		return FAILURE
	target = agent.target_tracker.last_tracked_endpoint
	var dir: Vector2 = target - agent.global_position
	if dir.length_squared() > tolerance:
		agent.move(dir)
	else:
		agent.move(Vector2.ZERO)
	return RUNNING
