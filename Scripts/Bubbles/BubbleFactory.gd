extends Node

class_name BubbleFactory

var mana_cost: float
var effect_types: Array = []
var bullet_type: int
var position: Vector2
var target: Vector2
var is_player_bullet: bool = false
var damage: float = 20

func _init():
	mana_cost = 0

func get_mana_cost() -> float:
	return mana_cost

func set_mana_cost(value: float) -> void:
	mana_cost = value

func apply(bubble: Bubble) -> BubbleFactory:
	for effect_type in effect_types:
		match effect_type:
			Constants.EffectType.NONE:
				pass
			Constants.EffectType.THE_WORLD:
				bubble.add_child(TheWorldBubbleEffectController.new())
			Constants.EffectType.TELEPORT:
				pass
			Constants.EffectType.FAST:
				bubble.add_child(FastBubbleEffectController.new())
			Constants.EffectType.DASH:
				bubble.add_child(DashBubbleEffectController.new())
			Constants.EffectType.BULLET:
				pass
			Constants.EffectType.ANTI:
				bubble.add_child(AntiBubbleEffectController.new())
			_:
				push_error("Unexpected EffectType: %s" % effect_type)
		
	bubble.position = position

	match bullet_type:
		Constants.BulletType.NONE:
			pass
		Constants.BulletType.TINY:
			bubble.add_child(BulletBubbleEffectController.new())
			bubble.linear_velocity = (target - position).normalized() * 100
			if is_player_bullet:
				bubble.add_child(PlayerBulletEffectController.new())
		Constants.BulletType.SUPPLEMENT:
			var b = SupplementBubbleEffectController.new()
			b.target_position = target
			bubble.add_child(b)
		_:
			push_error("Unexpected BulletType: %s" % bullet_type)
	bubble.damage = damage
	return self

func add_effect(effect_type: int) -> BubbleFactory:
	effect_types.append(effect_type)
	match effect_type:
		Constants.EffectType.THE_WORLD:
			mana_cost += 10
		Constants.EffectType.TELEPORT:
			mana_cost += 10
		Constants.EffectType.FAST:
			mana_cost += 5
		Constants.EffectType.DASH:
			mana_cost += 7
		Constants.EffectType.ANTI:
			mana_cost -= 3
		_:
			push_error("Unexpected EffectType: %s" % effect_type)
	return self

func make_bullet(bullet_type: int, position: Vector2, target: Vector2) -> BubbleFactory:
	self.bullet_type = bullet_type
	self.position = position
	self.target = target

	match bullet_type:
		Constants.BulletType.NONE:
			mana_cost *= 0
		Constants.BulletType.TINY:
			mana_cost *= 0.1
		Constants.BulletType.SUPPLEMENT:
			mana_cost *= 1
		_:
			push_error("Unexpected BulletType: %s" % bullet_type)

	return self

func originate_from_player(enemy_damage: float) -> BubbleFactory:
	is_player_bullet = true
	damage = enemy_damage
	return self
