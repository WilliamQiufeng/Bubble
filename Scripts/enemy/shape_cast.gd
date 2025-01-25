class_name TargetTracker1
extends ShapeCast2D

@onready var raycast_timer: Timer = $Timer
@onready var forget_timer: Timer = $ForgetTimer
@export var max_point_count = 10
@export var group_name: StringName = &"Player"
var player_endpoints: Array[Vector2] = []

var player_spotted: bool:
	get: return len(player_endpoints) > 0

var last_tracked_endpoint: Vector2:
	get: return player_endpoints.back()

func forget():
	if len(player_endpoints) > 0:
		player_endpoints.pop_front()

func check_raycast():
	for i in range(get_collision_count()):
		var body: Node2D = get_collider(i)
		#print(body, body.global_position, body.get_groups())
		if not body.is_in_group(group_name):
			continue
		player_endpoints.push_back(body.global_position)
		if (len(player_endpoints)) > max_point_count:
			forget()
