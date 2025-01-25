extends BTAction

@export var attack_name: NodePath
@export var node_name: StringName = &"Attack"

func _tick(delta):
	if not agent.has_node(attack_name):
		return FAILURE
	var attack: Attack = agent.get_node(attack_name)
	blackboard.set_var(node_name, attack)
	return SUCCESS
