extends TextureRect

func _physics_process(delta):
	visible = Game.player_movement.sword.visible
