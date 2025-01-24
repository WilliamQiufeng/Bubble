extends Sprite2D


@onready var textLabel:RichTextLabel = $TextLabel

var obj:Object
var text:String
var iconTexture:Texture2D
var iconScale:Vector2 = Vector2.ONE

var lerpPosition:Vector2 = Vector2.ZERO


func _ready():
	textLabel.set_text(text)
	var icon = $Icon
	icon.texture = iconTexture
	icon.scale = iconScale

func _physics_process(delta):
	if position.x < -132:
		queue_free()
	position = lerp(position,lerpPosition,0.2)
