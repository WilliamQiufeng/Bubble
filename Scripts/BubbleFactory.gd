extends Node

class_name BubbleFactory

var mana_cost: float
var effect_types: Array = []
var bullet_type: int
var position: Vector2
var target: Vector2

func _init():
	mana_cost = 0

func get_mana_cost() -> float:
	return mana_cost

func set_mana_cost(value: float) -> void:
	mana_cost = value

func apply(bubble: Node2D) -> BubbleFactory:
	for effect_type in effect_types:
		match effect_type:
			EffectType.NONE:
				pass
			EffectType.THE_WORLD:
				bubble.add_child(TheWorldBubbleEffectController.new())
			EffectType.TELEPORT:
				pass
			EffectType.FAST:
				bubble.add_child(FastBubbleEffectController.new())
			EffectType.DASH:
				bubble.add_child(DashBubbleEffectController.new())
			EffectType.BULLET:
				pass
			_:
				push_error("Unexpected EffectType: %s" % effect_type)
		
	bubble.position = position

	match bullet_type:
		BulletType.NONE:
			pass
		BulletType.TINY:
			bubble.add_child(BulletBubbleEffectController.new())
			bubble.linear_velocity = (target - position).normalized() * 100
		BulletType.SUPPLEMENT:
			var b = SupplementBubbleController.new()
			b.TargetPosition = target
			bubble.add_child(b)
		_:
			push_error("Unexpected BulletType: %s" % bullet_type)

	return self

func add_effect(effect_type: int) -> BubbleFactory:
	effect_types.append(effect_type)
	match effect_type:
		EffectType.THE_WORLD:
			mana_cost += 10
		EffectType.TELEPORT:
			mana_cost += 10
		EffectType.FAST:
			mana_cost += 5
		EffectType.DASH:
			mana_cost += 7
		_:
			push_error("Unexpected EffectType: %s" % effect_type)
	return self

func make_bullet(bullet_type: int, position: Vector2, target: Vector2) -> BubbleFactory:
	self.bullet_type = bullet_type
	self.position = position
	self.target = target

	match bullet_type:
		BulletType.NONE:
			mana_cost *= 0
		BulletType.TINY:
			mana_cost *= 0.1
		BulletType.SUPPLEMENT:
			mana_cost *= 1
		_:
			push_error("Unexpected BulletType: %s" % bullet_type)

	return self

# Enum-like classes for EffectType and BulletType
enum EffectType {
	NONE,
	THE_WORLD,
	TELEPORT,
	FAST,
	DASH,
	BULLET
}

enum BulletType {
	NONE,
	TINY,
	SUPPLEMENT
}
