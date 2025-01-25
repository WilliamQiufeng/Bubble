class_name ManaUpgrade
extends Upgrade

func _init() -> void:
	texture_path = "res://sprites/buff_mana.png"

func upgrade():
	Game.player.max_mana += 20
	print("Mana increased")
	destroy_window()
