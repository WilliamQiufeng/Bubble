extends AnimationPlayer
@onready var animation_player = $"."


# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.speed_scale = 0.2
	animation_player.play("new_animation")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
