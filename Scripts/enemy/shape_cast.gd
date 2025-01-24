class_name PlayerTracker
extends ShapeCast2D

@onready var timer: Timer = $Timer
@export var max_point_count = 10
var player_endpoints: Array[Vector2] = []

func check_raycast():
	for i in range(get_collision_count()):
		var body: Node2D = get_collider(i)
		if not body.is_in_group(&"Player"):
			continue
		print(body.global_position)
		player_endpoints.append(body.global_position)
		if len(player_endpoints) > max_point_count:
			player_endpoints.remove_at(0)
