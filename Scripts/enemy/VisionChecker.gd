extends Node

@onready var enemy = $".."

func check(other: Node2D) -> bool:
	var space_state = enemy.get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(
		enemy.global_position, other.global_position, 0b11, [enemy])
	var result = space_state.intersect_ray(query)
	return not result.is_empty() and result['collider'] == other
