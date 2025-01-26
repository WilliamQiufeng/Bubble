extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Loaded game scene")
	await G.createTimer(3).timeout
	#Scenes.switchScene("res://bubble.tscn")
	await Layers.dialogueBox.setAndDisplayQueueAndEnd(["@{name:TIP}Hello","hello twice"])
	Layers.dialogueBox.displayQueue()
	
	var upgrade_popup = load("res://UpgradePopup.tscn").instantiate()
	add_child(upgrade_popup)

func _physics_process(delta: float) -> void:
	pass
