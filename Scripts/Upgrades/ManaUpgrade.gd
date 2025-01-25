class_name ManaUpgrade
extends Interactable

@onready var upgrade_root = $".."

func _handle_interaction():
	Game.player.max_mana += 20
	upgrade_root.queue_free()
