class_name HealthUpgrade
extends Upgrade

func _init() -> void:
	texture_path = "res://sprites/banner.png"

func upgrade():
	Game.player.max_hp += 20
	print("Health increased")
	destroy_window()
