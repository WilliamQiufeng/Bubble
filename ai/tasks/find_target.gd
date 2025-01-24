extends BTAction

func _tick(delta):
	if agent.target_tracker.player_spotted:
		return SUCCESS
	return FAILURE
