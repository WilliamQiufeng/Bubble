class_name HealthRegenUpdate
extends Upgrade

func _init() -> void:
	texture_path = "res://sprites/Health potion.png"

func upgrade():
	Game.player.hp = max(Game.player.hp + 10, Game.player.max_hp)
	print("Health regenerated")
	destroy_window()
