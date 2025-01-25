extends BTAction

@export var tolerance: float = 300
@export var attack_node_name: StringName = &"Attack"

func _tick(delta):
	if not agent.target_tracker.player_spotted:
		return RUNNING
	var attack: Attack = blackboard.get_var(attack_node_name)
	var target: Vector2 = Game.player_movement.global_position
	var cur_pos: Vector2 = agent.global_position
	if (target - cur_pos).length_squared() > tolerance or not agent.can_reach_player():
		return RUNNING
	attack.attack()
	return SUCCESS
