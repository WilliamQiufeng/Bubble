extends Sprite2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var sprites = [
		preload("Lightning1.png"),
		preload("Lightning2.png"),
		preload("Lightning3.png"),
		preload("Lightning4.png"),
		preload("Lightning5.png"),
		preload("Lightning6.png"),
		preload("Lightning7.png"),
		preload("Lightning8.png")
	]
	texture = sprites[randi()%len(sprites)]
	scale = G.v2(4)
	flip_h = bool(randi()%2==0)
