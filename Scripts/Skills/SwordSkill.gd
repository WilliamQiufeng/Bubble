class_name SwordSkill
extends Skill

var damage: float = 10
var attack_animation: AnimationPlayer

func get_trigger_key(): return &"sword"
func get_bubble_cost(): return 10
func get_cooldown(): return 1

func use_skill():
	Audio.playEffect(preload("res://Misc/Effects/HeavyStrike.wav"))
	player.sword.melee()
