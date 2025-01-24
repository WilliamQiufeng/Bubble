extends CharacterBody2D

@export var sprite : AnimatedSprite2D
@export var idle_anim = &"idle_{type}"
@export var move_anim = &"move_{type}"
@onready var player_tracker = $PlayerTracker

var flip_h = false
var dir_str = "towards"

func _ready():
	sprite.play()

func _physics_process(delta):
	move_and_slide()
	
func find_dir_str(angle: float):
	while angle >= 2 * PI:
		angle -= 2 * PI
	while angle < 0:
		angle += 2 * PI
	var pi4 = PI / 4
	if angle < pi4 or angle >= 7 * pi4:
		dir_str = "left"
		flip_h = true
	elif angle >= pi4 and angle < 3 * pi4:
		dir_str = "away"
	elif angle >= 3 * pi4 and angle < 5 * pi4:
		dir_str = "left"

func move(speed: Vector2):
	var anim_str : StringName
	if speed == Vector2.ZERO:
		anim_str = idle_anim.format({"type": dir_str})
	else:
		var dir = speed.normalized()
		var angle = dir.angle_to(Vector2.RIGHT)
		player_tracker.rotation = -dir.angle_to(Vector2.DOWN)
		find_dir_str(angle)
		anim_str = move_anim.format({"type": dir_str})
	sprite.play(anim_str)
	sprite.flip_h = flip_h
	velocity = speed
