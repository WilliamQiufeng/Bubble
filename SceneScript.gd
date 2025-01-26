extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Loaded game scene")
	await G.createTimer(3).timeout
	#Scenes.switchScene("res://bubble.tscn")
	await Layers.dialogueBox.setAndDisplayQueueAndEnd(["@{name:SYSTEM}YOU'VE LANDED ON THE ENEMY MOTHERSHIP",
		"ELIMINATE ALL ENEMIES ON THE SHIP","@{name:TUTORIAL}Left click to fire bubbles, E to change fire mode",
		"Press 1/2/3 to select bubble type"]).dialogueEnded
	Game.afterTutorial = true
	Game.player.connect("player_death", display_death_screen)
	#var upgrade_popup = load("res://UpgradePopup.tscn").instantiate()
	#add_child(upgrade_popup)


func display_death_screen():
	Scenes.switchScene("res://Death.tscn")

func _physics_process(delta: float) -> void:
	pass
