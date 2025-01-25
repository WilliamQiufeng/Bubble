extends Node


var effects:Array[RefSfx] = []

func resetAutoLoad():
	for i in range(len(effects)-1,-1,-1):
		effects[i].finalize()
		effects.remove_at(i)
	

func _ready():
	process_mode = PROCESS_MODE_ALWAYS
	add_to_group("autoLoad")
	T.addToNoTimeZone(self)

func _physics_process(delta):
	for i in range(len(effects)-1,-1,-1):
		if !effects[i].isValid():
			effects[i].finalize()
			effects.remove_at(i)
			continue
		if T.canAdvance(effects[i],effects[i].timeZone):
			effects[i].fixedProcess()
			effects[i].lifetimeF -= 1

func _process(delta):
	for i in range(len(effects)-1,-1,-1):
		if !effects[i].isValid():
			effects[i].finalize()
			effects.remove_at(i)
			continue
		if T.canAdvance(effects[i],effects[i].timeZone):
			effects[i].frameProcess()
	

func emitParticles(p2d:GPUParticles2D,globalPosition:Vector2,parent:Node):
	p2d.one_shot = true
	p2d.local_coords = true
	p2d.global_position = globalPosition
	parent.add_child(p2d)
	T.addToNoTimeZone(p2d)
	await G.createMonitor(func(): return !p2d.emitting).quotaReached
	p2d.queue_free()
#always updateFree
func spawn(node:Node2D,arguments:Dictionary,lifetimeF:int=-1,parentNode:Node=Scenes.current()):
	parentNode.add_child(node)
	for key in arguments:
		node.set(key,arguments[key])
	if lifetimeF != -1:
		await T.setTimer(lifetimeF).timeout
		if is_instance_valid(node): node.queue_free()

func affect(refSfx:Script,args:Dictionary) -> RefSfx:
	var e:RefSfx = refSfx.new()
	G.setProperties(e,args,false)
	effects.append(e)
	e.initialize()
	return e
