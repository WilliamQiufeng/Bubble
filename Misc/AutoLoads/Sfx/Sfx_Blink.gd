extends RefSfx
#class_name RefSfxBlink

var speed:float = 0.2
var maxAlpha:float = 1
var minAlpha:float = 0
#var smooth:bool = false

var first:bool = true
var overlay = Sprite2D.new()
var targetAlpha:float = 0

func fixedProcess():
	if is_instance_valid(overlay):
		overlay.modulate.a = G.reach(overlay.modulate.a,targetAlpha,speed)

func frameProcess():
	if first:
		first = false
		target.add_child(overlay)
		overlay.material = ShaderMaterial.new()
		overlay.material.shader = preload("res://Assets/Misc/Shaders/WhiteWash.gdshader")
		if target is Sprite2D: overlay.texture = target.texture
	
	if target is AnimatedSprite2D: overlay.texture = G.getFrame(target)
	overlay.offset = target.offset
	overlay.flip_h = target.flip_h
	overlay.flip_v = target.flip_v
	overlay.global_position = target.global_position
	overlay.global_rotation = target.global_rotation
	overlay.global_transform = target.global_transform
	if overlay.modulate.a>=maxAlpha:
		targetAlpha = minAlpha
	elif overlay.modulate.a<=minAlpha:
		targetAlpha = maxAlpha
	

func isValid():
	return lifetimeF > 0 && is_instance_valid(target)
func finalize():
	if is_instance_valid(overlay):
		overlay.queue_free()
		
