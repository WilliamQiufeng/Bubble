extends RefSfx
class_name RefSfxTrail
#func get_class(): return "Custom"

var modulate:Color = Color.CYAN#TBS
var interval:int = 3 #TBS
var trailLifetime:int = 60*10 #TBS
var spawnTimeF:int = 60*3 #TBS
var deltaA:float = 0.05 #TBS
var whiteWash:bool = true #TBS

#var texture:Texture2D
var sprites:Array = []
			
func fixedProcess():
	assert(target is Sprite2D || target is AnimatedSprite2D, "Invalid target type")
	var texture:Texture = G.getFrame(target) if target is AnimatedSprite2D else target.texture
	for i in range(len(sprites)-1,-1,-1):
		if !is_instance_valid(sprites[i]):
			sprites.remove_at(i)
			continue
		sprites[i].modulate.a = G.reach0(sprites[i].modulate.a,deltaA)
		if G.nearEqual(sprites[i].modulate.a):
			sprites[i].queue_free()
			sprites.remove_at(i)
			continue
	
	spawnTimeF = G.reach0(spawnTimeF,1.0)
	if T.timer%interval != 0: return
	if spawnTimeF <= 0: return
	var newSprite = Sprite2D.new()
	sprites.append(newSprite)
	Sfx.spawn(newSprite,{},trailLifetime,container)
	newSprite.texture = texture
	newSprite.global_position = target.global_position
	newSprite.global_rotation = target.global_rotation
	container.move_child(newSprite,G.getAncestor(target,G.getNodePathLength(target,container)-1).get_index())
	#newSprite.z_index = G.getGlobalZIndex(target)-1 #OBSOLETE
	newSprite.offset = target.offset
	newSprite.flip_h = target.flip_h
	newSprite.flip_v = target.flip_v
	newSprite.modulate = modulate
	newSprite.material = ShaderMaterial.new()
	newSprite.material.shader = preload("res://Misc/Shaders/WhiteWash.gdshader")
	
func isValid():
	if lifetimeF <= 0 && len(sprites) <= 0: return false
	return is_instance_valid(target)

func finalize(): #OVR
	return
func end(): #OVR
	spawnTimeF = 0
