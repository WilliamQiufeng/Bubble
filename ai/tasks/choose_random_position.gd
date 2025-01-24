extends BTAction

@export var min_range: float = 40
@export var max_range: float = 100

@export var position_var: StringName = &"pos"
@export var direction_var: StringName = &"dir"

func _tick(delta: float) -> Status:
	var pos: Vector2
	var dir = random_dir()
	pos = random_pos(dir)
	blackboard.set_var(position_var, pos)
	print("dir: ", dir, ", pos: ", pos)
	return SUCCESS

func random_pos(dir: Vector2):
	var distance = randf_range(min_range, max_range)
	var dp = distance * dir
	var final_pos = agent.global_position + dp
	return final_pos

func random_dir():
	var dir = Vector2.from_angle(randf_range(-PI, PI))
	blackboard.set_var(direction_var, dir)
	return dir
