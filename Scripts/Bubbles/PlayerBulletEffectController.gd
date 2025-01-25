class_name PlayerBulletEffectController
extends BubbleEffectController

func set_bubble_appearance():
	pass

func _handle_enemy_enter(enemy: Enemy):
	enemy._get_damage(bubble_controller.bubble.damage)
	bubble_controller.explode()
