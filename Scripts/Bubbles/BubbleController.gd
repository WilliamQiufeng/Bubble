class_name BubbleController
extends Area2D

# Properties
@onready var scale_node: Node2D = $".."
@onready var collision_shape: CollisionShape2D = $".."
@onready var animation: AnimationPlayer = $AnimationPlayer

var bubble: Node2D

func delete():
	animation.play("Bubble")

func get_effect_type() -> Constants.EffectType:
	var effect_type = Constants.EffectType.NONE
	for child in bubble.get_children():
		if child is BubbleEffectController:
			effect_type |= child.effect_type
	return effect_type

func _ready() -> void:
	bubble = owner as Node2D

func get_area() -> float:
	return collision_shape.shape.get_rect().get_area() * scale_node.scale.x

func set_area(value: float) -> void:
	var scaling_factor = sqrt(value / get_area())
	scale_node.scale = Vector2(scale_node.scale.x * scaling_factor, scale_node.scale.y * scaling_factor)

func on_bubble_area_entered(area: Area2D) -> void:
	if bubble.is_queued_for_deletion():
		return
	if area is not BubbleController:
		return

	var other_bubble_controller = area as BubbleController
	print("%s hit with %s" % [get_effect_type(), other_bubble_controller.get_effect_type()])

	if not Constants.is_same_type(other_bubble_controller.get_effect_type(), get_effect_type())\
		or 	Constants.is_bullet(get_effect_type()) and not Constants.is_bullet(other_bubble_controller.get_effect_type()):
		return

	print(get_effect_type(), "vs", other_bubble_controller.get_effect_type())
	other_bubble_controller.bubble.queue_free()
	print("Previous area: %s" % get_area())
	set_area(get_area() + other_bubble_controller.get_area())
	print("Now area: %s" % get_area())

func on_bubble_area_exited(area: Area2D) -> void:
	pass
