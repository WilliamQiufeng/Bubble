extends BTAction

@export var tolerance: float = 200

@export var target: Vector2

var navigation_agent: NavigationAgent2D:
	get: return agent.navigation_agent

func _tick(delta):
	if not agent.target_tracker.player_spotted:
		return FAILURE
	target = agent.target_tracker.last_tracked_endpoint
	navigation_agent.target_position = target
	var next_pos = navigation_agent.get_next_path_position()
	var dir: Vector2 = agent.global_position.direction_to(next_pos)
	var dist_sq_to_player = (target - agent.global_position).length_squared()
	if dist_sq_to_player > tolerance or not agent.can_reach_player():
		agent.move(dir)
	else:
		agent.move(Vector2.ZERO)
	return RUNNING
