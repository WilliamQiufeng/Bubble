class_name BubbleController
extends Area2D

# Properties
@onready var scale_node: Node2D = $".."
@onready var collision_shape: CollisionShape2D = $".."
@onready var animation: AnimationPlayer = $"../../AnimationPlayer"
var to_be_deleted = false

@onready var bubble: Bubble = $"../.."

func _delete(_name: StringName):
	bubble.queue_free()
	to_be_deleted = true

func explode():
	if to_be_deleted:
		return
	animation.play("Bubble")
	to_be_deleted = true
	animation.animation_finished.connect(_delete)

func get_effect_type() -> Constants.EffectType:
	var effect_type = Constants.EffectType.NONE
	for child in bubble.get_children():
		if child is BubbleEffectController:
			effect_type |= child.effect_type
	return effect_type

func _physics_process(delta):
	if Constants.is_bullet(get_effect_type()):
		set_area(get_area() - delta * 50)
	else:
		set_area(get_area() - delta * 200)

func get_area() -> float:
	return collision_shape.shape.get_rect().get_area() * scale_node.scale.x

func get_radius() -> float:
	print("radius is " + str(collision_shape.shape.radius))
	return collision_shape.shape.radius

func set_area(value: float) -> void:
	var scaling_factor = sqrt(value / get_area())
	scale_node.scale = Vector2(scale_node.scale.x * scaling_factor, scale_node.scale.y * scaling_factor)
	if get_area() < 300 and not Constants.is_bullet(get_effect_type()):
		_delete(&"")

func on_bubble_area_entered(area: Area2D) -> void:
	if to_be_deleted:
		return
	if area is not BubbleController:
		return

	var other_bubble_controller = area as BubbleController
	var this_effect = get_effect_type()
	var other_effect = other_bubble_controller.get_effect_type()
	#print("%s hit with %s" % [get_effect_type(), other_effect])

	var other_is_anti = Constants.is_anti(other_effect)
	var both_is_anti = Constants.is_anti(this_effect) and other_is_anti
	if (not Constants.is_same_type(other_effect, this_effect)
			and not other_is_anti)\
		or 	(Constants.is_bullet(this_effect) and not Constants.is_bullet(other_effect)):
		return

	print(get_effect_type(), "vs", other_bubble_controller.get_effect_type())
	other_bubble_controller._delete("")
	bubble.damage += other_bubble_controller.bubble.damage
	#print("Previous area: %s" % get_area())
	if other_is_anti and not both_is_anti:
		set_area(get_area() - other_bubble_controller.get_area())
	else:
		set_area(get_area() + other_bubble_controller.get_area())
		
	#print("Now area: %s" % get_area())

func on_bubble_area_exited(area: Area2D) -> void:
	pass
