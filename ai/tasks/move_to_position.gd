extends BTAction

@export var target_pos_var := &"pos"
@export var dir_var := &"dir"

@export var speed := 40
@export var tolerance := 100

func _tick(delta: float) -> Status:
	var target_pos: Vector2 = blackboard.get_var(target_pos_var, Vector2.ZERO)
	var dir: Vector2 = blackboard.get_var(dir_var)
	var error: Vector2 = agent.global_position - target_pos
	if error.length_squared() < tolerance:
		agent.move(Vector2.ZERO)
		return SUCCESS
	else:
		agent.move(dir * speed)
		return RUNNING
