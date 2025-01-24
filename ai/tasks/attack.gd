extends BTAction

@export var tolerance: float = 300

func _tick(delta):
	if not agent.target_tracker.player_spotted:
		return RUNNING
	var target: Vector2 = Game.player_movement.global_position
	var cur_pos: Vector2 = agent.global_position
	if (target - cur_pos).length_squared() > tolerance:
		return RUNNING
	agent.attack()
	return SUCCESS
