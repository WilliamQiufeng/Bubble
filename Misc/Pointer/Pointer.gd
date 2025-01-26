extends Sprite2D

var lerpPositionY:float = 0
var lerpPositionX:float = 0
var lerpScale:float = 0.3

func _process(delta):
	position.y = lerp(position.y,lerpPositionY,lerpScale)
	position.x = lerp(position.x,lerpPositionX,lerpScale)
