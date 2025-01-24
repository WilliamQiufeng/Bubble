class_name CharacterState
extends LimboState

@export var animation_name : StringName

func _enter():
	agent.sprite.play(animation_name)
