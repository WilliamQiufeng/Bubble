class_name AnimationMovement
extends Node

class AnimationCommand:
	var flip_h: bool
	var dir_str: StringName
	func _init(flip_h: bool, dir_str: StringName):
		self.flip_h = flip_h
		self.dir_str = dir_str

@export var character: CharacterBody2D
@export var sprite : AnimatedSprite2D
@export var idle_anim = &"idle_{type}"
@export var move_anim = &"move_{type}"
@export var die_anim = &"die_{type}"
@export var hit_anim_prefix = &"hit_"
@export var orientation_node : Node2D

var deferred_anim_prefix : StringName = &""
var flip_h = false
var dir_str = "towards"
var dead = false

func _ready():
	sprite.play()
	sprite.animation_finished.connect(_play_deferred)
	
func find_dir_str(angle: float):
	while angle >= 2 * PI:
		angle -= 2 * PI
	while angle < 0:
		angle += 2 * PI
	var pi4 = PI / 4
	flip_h = false
	dir_str = "towards"
	if angle < pi4 or angle >= 7 * pi4:
		dir_str = "left"
		flip_h = true
	elif angle >= pi4 and angle < 3 * pi4:
		dir_str = "away"
	elif angle >= 3 * pi4 and angle < 5 * pi4:
		dir_str = "left"
	direction_changed.emit(AnimationCommand.new(flip_h, dir_str))

signal direction_changed(cur_state: AnimationCommand)

func is_attacking():
	return sprite.is_playing() and sprite.animation.begins_with(hit_anim_prefix)

func set_dir(dir: Vector2):
	var dir_unit = dir.normalized()
	var angle = dir_unit.angle_to(Vector2.RIGHT)
	orientation_node.rotation = -dir_unit.angle_to(Vector2.DOWN)
	find_dir_str(angle)

func _play_deferred():
	if deferred_anim_prefix.is_empty():
		return
	_play_format(deferred_anim_prefix)
	deferred_anim_prefix = &""

func _play(name: StringName):
	if dead:
		return
	sprite.play(name)
	sprite.flip_h = flip_h

func _play_format(template: StringName):
	if is_attacking():
		deferred_anim_prefix = template
		return
	_play(template.format({"type": dir_str}))

func idle():
	_play_format(idle_anim)

func move():
	_play_format(move_anim)

func play(template: StringName):
	_play_format(template)

func die():
	if dead:
		return
	sprite.stop()
	_play_format(die_anim)
	dead = true
