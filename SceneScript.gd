extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Loaded game scene")
	await G.createTimer(3).timeout
	#Scenes.switchScene("res://bubble.tscn")
	await Layers.dialogueBox.setAndDisplayQueueAndEnd(["@{name:TIP}Hello","hello twice"])
	Layers.dialogueBox.displayQueue()
	

func _physics_process(delta: float) -> void:
	pass
