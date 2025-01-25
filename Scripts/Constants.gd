class_name Constants
enum EffectType {
	NONE = 0,
	THE_WORLD = 1 << 0,
	TELEPORT = 1 << 1,
	FAST = 1 << 2,
	DASH = 1 << 3,
	ANTI = 1 << 29,
	BULLET = 1 << 30
}

enum BulletType {
	NONE,
	TINY,
	SUPPLEMENT
}

static func is_bullet(effect_type: EffectType) -> bool:
	return (effect_type & EffectType.BULLET) != 0

static func remove_bullet(effect_type: EffectType) -> EffectType:
	return effect_type & ~EffectType.BULLET as EffectType

static func is_anti(effect_type: EffectType) -> bool:
	return (effect_type & EffectType.ANTI) != 0

static func is_same_type(effect_type: EffectType, other_effect_type: EffectType) -> bool:
	return remove_bullet(effect_type) == remove_bullet(other_effect_type)
