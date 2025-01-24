extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Loaded game scene")
	await G.createTimer(5).timeout
	await Layers.dialogueBox.setAndDisplayQueueAndEnd(["Hello"])

func _physics_process(delta: float) -> void:
	pass
