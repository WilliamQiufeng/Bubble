class_name Interactable
extends Node

@export var collision_object: Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	Game.player_movement.interact.connect(_check_interact)

func _exit_tree():
	Game.player_movement.interact.disconnect(_check_interact)
	

func _handle_interaction():
	pass

func _check_interact(node: Node2D):
	if collision_object != node:
		return
	_handle_interaction()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
