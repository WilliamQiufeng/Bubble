extends Node

const DEFAULT_GRAVITY_DIR = Vector2(0,1)
const DEFAULT_GRAVITY_MAG = 20

const DEFAULT_VECTOR2:Vector2 = Vector2.INF
#file structure shorthands
const SCENES_PATH:String = "res://Assets/Scenes/"
const CHARACTERS_PATH:String = "res://Assets/Standalone/Dynamic/Characters/"
const SONGS_PATH:String = "res://Assets/Audio/Songs/"
const EFFECTS_PATH:String = "res://Misc/Effects/"
#const ITEMS_PATH:String = "res://Assets/Standalone/Abstract/Items/"


var inputActionFrames:Dictionary = {}

var allNodes:Array[Node] = []
var sceneNodes:Array[Node] = []
var callOnAllNodes:Array[Callable] = []

var notificationCenter:Dictionary = {}

var DEBUGGING = true

#READY & PROCESS
#initializes and updates
func _________INIT_LOOP(): pass

func _ready():
	process_mode = PROCESS_MODE_ALWAYS
	T.addToNoTimeZone(self)
	for a in InputMap.get_actions(): inputActionFrames[a] = 0
	TranslationServer.set_locale("en") #english as default
	get_window().mode = Window.MODE_EXCLUSIVE_FULLSCREEN if (!((get_window().mode == Window.MODE_EXCLUSIVE_FULLSCREEN) or (get_window().mode == Window.MODE_FULLSCREEN))) else Window.MODE_WINDOWED
	

var monitors:Array = []
var nts:Dictionary = {}
var characterBeacons:Dictionary = {}
	
func _physics_process(delta):
	diagnose()
	updateVars()
	#process Ref_Monitors
	for i in range(len(monitors)-1,-1,-1):
		if monitors[i].durability == 0:
			monitors.remove_at(i)
			continue
		monitors[i].fixedProcess()
	diagnose()
	
	var bin = []
	for key in nts:
		if !nts[key].isValid():
			bin.append(key)
			continue
		nts[key].fixedProcess()
	for k in bin: nts.erase(k)
	bin.clear()
	diagnose()
	
	#for n in allNodes:
		#for c in callOnAllNodes:
			#c.call(n)
	for a in inputActionFrames:
		if pressed(a): #DO NOT put the two ifs on one line, IT BREAKS
			if inputActionNotDeprecated(a): inputActionFrames[a] += 1
		#only reset input action after 'just released' period passes
		#in order to not alter results of justReleased if a was deprecated
		elif !justReleased(a,true): #equiv to raw Input.is_input_just_released
			inputActionFrames[a] = 0
	diagnose()
	
	#fullscreen
	if justPressed("fullscreen"):
		get_window().mode = Window.MODE_EXCLUSIVE_FULLSCREEN if (!((get_window().mode == Window.MODE_EXCLUSIVE_FULLSCREEN) or (get_window().mode == Window.MODE_FULLSCREEN))) else Window.MODE_WINDOWED

signal trigger
#TRIGGERS
#triggers some function or some action
func __________TRIGGERS(): pass
func updateVars() -> void:
	pass
	#allNodes = getAllNodes()
func diagnose(): return
func logMessage(s:String,level:int=0) -> void: #for diagnostic purposes
	diagnose()
	for i in level:
		s = " --- " + s
	#print(s)
func emitAndLogMessage(s:Signal,level:int=0):
	logMessage("Emit signal: "+ s.get_name() + " from " + str(s.get_object()) + " to " + str(s.get_connections()))
	s.emit()
func followNotification(callable:Callable,notif:String):
	if !notificationCenter.has(notif): notificationCenter[notif] = []
	if !(callable in notificationCenter[notif]): notificationCenter[notif].append(callable)
func unfollowNotification(callable:Callable,notification:String): if notificationCenter.has(notification): notificationCenter[notification].erase(callable)
func notify(notif:String,msg:Dictionary={}) -> bool:
	G.diagnose()
	G.logMessage("Notify: "+notif,1)
	if !notificationCenter.has(notif): #notif no followers
		G.logMessage("Notify: "+notif+" has no followers",1)
		return false
	var callables:Array = notificationCenter[notif]
	for i in range(len(callables)-1,-1,-1):
		var callable = callables[i]
		if !callable.is_valid():
			callables.remove_at(i)
			continue
		callable.call(msg)
	G.diagnose()
	return true
func resetAutoLoads():
	for autoLoad in get_tree().get_root().get_children():
		if autoLoad == Scenes.current(): continue
		for n in getSubNodes(autoLoad): safeCall(n,"resetAutoLoad")
func freeChildren(node:Node): for c in node.get_children(): c.queue_free()
func pauseTree(paused:bool,ignorePhysics:bool=true):
	get_tree().paused = paused
	if ignorePhysics: PhysicsServer2D.set_active(true)
func callGroup(group:String,function:String): for node in getNodes(group): node.call(function)
func callvGroup(group:String,function:String,args:Array): for node in getNodes(group): node.callv(function,args)
func safeQueueFree(node:Node) -> void: if is_instance_valid(node): node.queue_free()
func safeCall(node,function): if is_instance_valid(node) && node.has_method(function): node.call(function)
func setTimer(seconds:float,persistent:bool=false)->Object: return createTimer(seconds,true,T.TZ.NONE,persistent)
func createTimer(seconds:float,oneshot:bool=true,timeZone:int=T.TZ.WORLD,persistent:bool=false)->Object:
	return T.createTimer(s2f(seconds),oneshot,timeZone,persistent)
func trackNode(node,interval:int=1,directionInterval:int=5):
	var tracker = nts[node]
	tracker.interval = interval
	tracker.directionInterval = directionInterval
	return tracker
func deprecateInputAction(action:String) -> void: inputActionFrames[action] = -1 #block until release
func deprecateAllInputActions() -> void: for action in inputActionFrames: inputActionFrames[action] = -1
func smartPlayAnimatedSprite(animatedSprite:AnimatedSprite2D,animation:String):
	assert(animatedSprite.sprite_frames.has_animation(animation),"Animation "+animation+" not found")
	if animatedSprite.animation != animation || (!animatedSprite.is_playing() && animatedSprite.frame < animatedSprite.sprite_frames.get_frame_count(animatedSprite.animation)-1):
		animatedSprite.play(animation)

#GETTERS
#gets and returns some data or node
func ___________GETTERS(): pass
func pressed(action:String) -> bool: return Input.is_action_pressed(action)
func justPressed(action:String,deprecateIfTrue:bool=true) -> bool:
	var r:bool = Input.is_action_just_pressed(action)
	#'consumes' the action to prevent a justReleased from detecting it
	if r && deprecateIfTrue: deprecateInputAction(action)
	return r
func justReleased(action:String,ignoreDeprecated:bool=false) -> bool: return Input.is_action_just_released(action) && (inputActionNotDeprecated(action) || ignoreDeprecated)
func justPressedAndReleased(action:String,maxPressedFrames:int=10) -> bool: return justReleased(action) && inputActionFrames[action]<=maxPressedFrames
func inputActionNotDeprecated(action:String): return inputActionFrames[action] >= 0
func getNode(group:String) -> Node: return getNodes(group)[0] #returns the first node in the given group
func getNodes(group:String) -> Array[Node]: #returns all nodes (not queued for freeing) in the given group
	return get_tree().get_nodes_in_group(group).filter(func(n): return !n.is_queued_for_deletion())
func cameraBoxExists() -> bool: return len(getNodes("cameraBox"))>0
func fps() -> int: return Engine.get_frames_per_second()#returns current fps
func getAllNodes() -> Array[Node]: return  [] # getSubNodes(get_tree().get_root())
func getSubNodes(node:Node) -> Array[Node]: #the node + all descendents
	var r:Array[Node] = []
	r.append(node)
	for n in node.get_children(): r.append_array(getSubNodes(n))
	return r
func getAncestors(node:Node) -> Array[Node]:
	var r:Array[Node] = []
	while node.get_parent() != get_tree().root:
		node = node.get_parent()
		r.append(node)
	return r
func getAncestor(node:Node,depth:int) -> Node:
	for i in depth: node = node.get_parent()
	return node
func getNodePathLength(from:Node,to:Node) -> int:
	return from.get_path_to(to).get_name_count()
func getCameraBox() -> Node2D:
	var cams = getNodes("cameraBox")
	if len(cams)>0: return cams[0]
	else: return null
func getSpawnPoints() -> Array:
	var r:Array = []
	for n in allNodes:
		for g in n.get_groups():
			if g.begins_with("sp_"):
				r.append(n)
				break
	return r

#OPERATIONS
#operates on and returns some values
func ________OPERATIONS(): pass
func callOnVec(v:Vector2,callable:Callable): return Vector2(callable.call(v.x),callable.call(v.y))
func callOnX(v:Vector2,callable:Callable): return Vector2(callable.call(v.x),v.y)
func callOnY(v:Vector2,callable:Callable): return Vector2(v.x,callable.call(v.y))
func globalPosToScreenPos(gPos:Vector2,viewport:Viewport=get_viewport()): #DEBUG
	return viewport.get_screen_transform()*viewport.get_final_transform()*gPos
func screenPosToGlobalPos(screenPos:Vector2,viewport:Viewport=get_viewport()): #DEBUG
	return (viewport.get_screen_transform()*viewport.get_final_transform()).inverse()*screenPos
func moveColorToward(color:Color,targetColor:Color,amount:float):
	return Color(G.reach(color.r,targetColor.r,amount),G.reach(color.g,targetColor.g,amount),
	G.reach(color.b,targetColor.b,amount),G.reach(color.a,targetColor.a,amount))
func inRange2(v:Vector2,minRange:Vector2,maxRange:Vector2,mirror:bool=false) -> bool:
	return inRange(v.x,minRange.x,maxRange.x,mirror) && inRange(v.y,minRange.y,maxRange.y,mirror)
func inRange(n:float,minRange:float,maxRange:float,mirror:bool=false) -> bool:
	if mirror: return abs(n)>=abs(minRange) && abs(n)<=abs(maxRange)
	return n>=minRange && n<=maxRange
func restrict2(v:Vector2,minimum:Vector2,maximum:Vector2,mirror:bool=false) -> Vector2:
	return Vector2(restrict(v.x,minimum.x,maximum.x,mirror),restrict(v.y,minimum.y,maximum.y,mirror))
func restrict(n:float,minimum:float,maximum:float,mirror:bool=false) -> float:
	if mirror:
		if abs(n)<abs(minimum): return sign(n)*minimum
		if abs(n)>abs(maximum): return sign(n)*maximum
		return n
	if n<minimum: return minimum
	if n>maximum: return maximum
	return n
func frac(n:float) -> float: return n - int(n)
func s2f(s:float) -> float: return 60*s
func f2s(f:float) -> float: return f/60
func int2arr(n:int) -> Array:
	var r = str2arr(str(n))
	for i in len(r): r[i] = int(r[i])
	return r
func str2arr(s:String) -> Array[String]:
	var r:Array[String] = []
	for c in s: r.append(c)
	return r
#gets the readable name of the key located on the position of the given physical key
func getKeycodeStringFromPhysical(physicalKeycode:Key): OS.get_keycode_string(DisplayServer.keyboard_get_keycode_from_physical(KEY_0))#WORRY int instead?
#mrcdk
#https://github.com/godotengine/godot-proposals/issues/5056#issuecomment-1203033323
func stripBbcode(str:String) -> String: 
	var regex = RegEx.new()
	regex.compile("\\[.+?\\]")
	return regex.sub(str, "", true)
func remainder2(vn:Vector2,vd:Vector2) -> Vector2: return Vector2(int(vn.x)%int(vd.x),int(vn.y)%int(vd.y))
func db2percent(db:float) -> float: return pow(10,db/10)
func percent2db(p:float) -> float: return 10*log(p)
func cap(s:String) -> String:
	var c = s.substr(0,1)
	s = s.substr(1)
	return c.to_upper()+s
func uncap(s:String) -> String:
	var c = s.substr(0,1)
	s = s.substr(1)
	return c.to_lower()+s
func checkAtt(obj:Object,att:String,value) -> bool: return (typeof(obj.get(att))==typeof(value) && obj.get(att) == value)
func flip(v:Vector2) -> Vector2: return Vector2(v.y,v.x)
func logarithm(base:float,of:float) -> float:
	if base == 1: return 1.0
	return log(of)/log(base)
func getGlobalZIndex(node:Node2D) -> int:
	if !node.z_as_relative: return node.z_index
	var z = node.z_index
	while node.get_parent() is Node2D:
		node = node.get_parent()
		z+=node.z_index
	return z
func setGlobalZIndex(node:Node2D,globalZIndex:int) -> void:
	if node.z_as_relative:
		node.z_index = globalZIndex
		return
	node.z_index = globalZIndex - getGlobalZIndex(node.get_parent())
func getFrame(animatedSprite:AnimatedSprite2D) -> Texture2D: return animatedSprite.sprite_frames.get_frame_texture(animatedSprite.animation,animatedSprite.frame)
func getProperties(variant,keepAllObjects:bool=true): #keepAllObjects for only 1 layer
	if variant == null || (variant is Object && !is_instance_valid(variant)): return null
	var r
	match typeof(variant):
		TYPE_OBJECT:
			if variant is Node && !keepAllObjects: return null
			r = {}
			var properties:Array[Dictionary] = variant.get_property_list()
			var unsaved:Array[String] = ["script"]
			var saved:Array[String] = []
			var mustSave:Array[String] = ["scene_file_path"]
			for i in range(len(properties)-1,-1,-1):
				var p:String = properties[i].name
				if !(p in variant): #remove c++ built-in props
					properties.remove_at(i)
					continue
				if p.begins_with("unsaved_"):
					unsaved.append_array(variant.get(p))
					properties.remove_at(i) #don't save the unsaved array itself
				elif p.begins_with("saved_"):
					saved.append_array(variant.get(p))
					properties.remove_at(i) #don't save the saved array itself
			#save only properties in saved[] (ignoring unsaved[]), if the array has sth, except items in mustSave[]
			if len(saved)>0: #save only the props in saved_ array
				for p in saved: #save props in saved[]
					assert(p in variant,"saved_ array has non-existent property "+p)
					var value = getProperties(variant.get(p),false)
					if value != null: r[p] = value
				for p in mustSave: #save props in mustSave[]
					assert(p in variant,"mustSave array has non-existent property "+p)
					if p in saved: continue
					var value = getProperties(variant.get(p),false)
					if value != null: r[p] = value
			else: #save all props except for props in unsaved
				for p in unsaved: #remove unsaved props from prop list
					assert(p in variant,"unsaved_ array has non-existent property "+p)
					for i in range(len(properties)-1,-1,-1):
						if p == properties[i].name:
							properties.remove_at(i)
							break
				for p in properties: #save props w/o unsaved props
					var value = getProperties(variant.get(p.name),false)
					if value != null: r[p.name] = value
					
			var script:GDScript = variant.get_script()
			if variant is Node:
				r["@groups"] = variant.get_groups()
				r["@scene"] = Scenes.getCurrentScenePath()#WORRY wrong currentScene
				if script == null: r["@nodeScript"] = ""
				else: r["@nodeScript"] = script.resource_path
			elif variant is Resource: #only resource objs have @resScript
				if script == null: r["@resScript"] = ""
				else: r["@resScript"] = script.resource_path
			else: #only non-node & non-resource objs have @objScript
				if script == null: return null
				else: r["@objScript"] = script.resource_path
				
		TYPE_ARRAY:
			r = []
			for item in variant: r.append(getProperties(item,false))
		TYPE_DICTIONARY:
			assert(!variant.has("@nodeScript") && !variant.has("@resScript") && !variant.has("@objScript"),
				"Properties dictionary cannot have reserved key names")
			r = {}
			for key in variant: r[key] = getProperties(variant[key],false)
		_: r = variant
	return r
func setProperties(variant,properties,safe:bool=true,initial:bool=true):
	if initial:
		if variant is Node:
			assert(properties is Dictionary && properties.has("@nodeScript"),"Properties dict must have @nodeScript")
			if properties["@nodeScript"] == "": variant.set_script(null)
			else:
				variant.set_script(load(properties["@nodeScript"]))
				variant.set_process(true)
				variant.set_physics_process(true) #off by default for a scene with no script
		var globalProperties:Array = [] #set later to overwrite any local properties
		for key in properties: #set properties
			if key == "@groups" && variant is Node:
				for g in variant.get_groups(): variant.remove_from_group(g)
				for g in properties["@groups"]: variant.add_to_group(g)
				continue #cannot have property called '@groups'
			assert(safe||key in variant,"Property not in variant")
			if !(key in variant): continue #if the object has no given property
			if key.begins_with("global_"): globalProperties.append(key)
			else: variant.set(key,setProperties("",properties[key],safe,false))
		for key in globalProperties: #global prop names are the keys of property{}
			variant.set(key,setProperties("",properties[key],safe,false))
		return variant
	match typeof(properties):
		TYPE_DICTIONARY:
			if properties.has("@resScript"):
				var res:Resource
				if properties["@resScript"] == "": res = load(properties["resource_path"])
				else: res = load(properties["@resScript"]).new()
				for key in properties:
					assert(safe||key in res,"Property not in Resource")
					res.set(key,properties[key])
				return res
			elif properties.has("@objScript"):
				var obj:Object = load(properties["@objScript"]).new()
				for key in properties:
					assert(safe||key in obj,"Property not in Object")
					obj.set(key,properties[key])
				return obj
			else:
				var dict:Dictionary = {}
				for key in properties: dict[key] = setProperties("",properties[key],safe,false)
				return dict
		TYPE_ARRAY:
			var arr:Array = []
			for i in range(len(properties)): arr.append(setProperties("",properties[i],safe,false))
			return arr
		_: return properties
func addGroup(node:Node,group:String): if !node.is_in_group(group): node.add_to_group(group)
func removeGroup(node:Node,group:String): if node.is_in_group(group): node.remove_from_group(group)
func addGroups(node:Node,groups:Array): for g in groups: addGroup(node,g)
func removeGroups(node:Node,groups:Array): for g in groups: removeGroup(node,g)
func putInGroup(node:Node,group:String,inGroup:bool):
	if inGroup: if !node.is_in_group(group): node.add_to_group(group)
	elif node.is_in_group(group): node.remove_from_group(group)
func isUnderGroup(node:Node,group:String):
	assert(node.is_inside_tree(),"Don't use this function on an orphan node")
	var root = get_tree().get_root()
	while node != root:
		if node.is_in_group(group): return true
		node = node.get_parent()
	return false
func getGroupsAbove(node:Node) -> Array:
	assert(node.is_inside_tree(),"Don't use this function on an orphan node")
	var r = []
	var root = get_tree().get_root()
	while node != root:
		r.append_array(node.get_groups())
		node = node.get_parent()
	return r
func eraseAll(arr:Array,value): for i in range(len(arr)-1,-1,-1): if arr[i] == value: arr.remove_at(i)
func replaceFirst(text:String,replacee:String,replacer:String) -> String:
	var i:int = text.find(replacee)
	if i>=0:
		text = text.erase(i,replacee.length())
		text = text.insert(i,replacer)
	return text
func v2(m): return Vector2(m,m)
func pow2(v,p): return Vector2(pow(v.x,p),pow(v.y,p))
func sign2(v:Vector2): return Vector2(sign(v.x),sign(v.y))
func avg(array:Array): return sum(array)/len(array)
func sum(array:Array):
	var sum = 0
	if array[0] is Vector2: sum = Vector2.ZERO
	for i in array: sum+=i
	return sum
func roughlyEqual(a:float,b:float,epsilon:float): return abs(a-b) < abs(epsilon)
func nearEqual(a:float,b:float = 0.0): return is_equal_approx(a,b)
func nearEqual2(v1:Vector2,v2:Vector2 = Vector2.ZERO): return nearEqual(v1.x,v2.x) && nearEqual(v1.y,v2.y)
func sureGreater(a:float,b:float = 0.0): return a > b && !nearEqual(a,b)
func sureLess(a:float,b:float = 0.0): return a < b && !nearEqual(a,b)
func reach(n:float,limit:float,amount:float):#advances a value towards another by an amount
	if n>limit:
		n-=amount
		if n<limit: return limit
	elif n<limit:
		n+=amount
		if n>limit: return limit
	return n
func reach2(v:Vector2,limit:Vector2,amount:Vector2) -> Vector2: return Vector2(reach(v.x,limit.x,amount.x),reach(v.y,limit.y,amount.y))
func reach0(n:float,amount:float) -> float: return reach(n,0,amount)
func reach02(v:Vector2,amount:Vector2) -> Vector2: return reach2(v,Vector2.ZERO,amount)
func tolerate(n,target,tolerance=0.01): #returns the target value if n is close enough to the target value
	if abs(n-target)<abs(target*tolerance)+tolerance: return target
	return n
func tolerate2(n,target,tolerance=Vector2(0.1,0.1)) -> Vector2: return Vector2(tolerate(n.x,target.x,tolerance.x),tolerate(n.y,target.y,tolerance.y))
func abs1(n:float) -> float: return abs(n) #wrapper
func abs2(v:Vector2) -> Vector2: return Vector2(abs(v.x),abs(v.y))#returns the absolute value of a Vector2
func lerp2(v:Vector2,t:Vector2,w:Vector2) -> Vector2: return Vector2(lerp(v.x,t.x,w.x),lerp(v.y,t.y,w.y))#lerps the x and y of a Vector2
func lerpDistance(n,target,weight): return (target-n)*weight#calculates the actual distance of a lerp
func safeGetDictValue(dict:Dictionary,keys:Array):
	var key
	for i in len(keys):
		key = keys[i]
		if dict.has(key) && dict[key] is Dictionary: dict = dict[key]
		else: return null
	return dict[key]
func safeSetDictValue(dict:Dictionary,keys:Array,value,recursiveCreate:bool=true,overwriteWithDict:bool=true) -> bool:
	var key
	for i in len(keys)-1:
		key = keys[i]
		if !dict.has(key):
			if recursiveCreate: dict[key] = {}
			else: return false
		elif !(dict[key] is Dictionary):
			if overwriteWithDict: dict[key] = {}
			else: return false
		dict = dict[key]
	key = keys[len(keys)-1]
	dict[key] = value
	return true
func safeCompareDictValue(dict:Dictionary,keys:Array,comparison) -> bool:
	var key
	for i in len(keys)-1:
		key = keys[i]
		if dict.has(key) && dict[key] is Dictionary: dict = dict[key]
		else: return false
	key = keys[len(keys)-1]
	if !dict.has(key): return false
	return typeof(dict[key]) == typeof(comparison) && dict[key] == comparison
func dictKeyExists(dict:Dictionary,keys:Array) -> bool:
	for i in len(keys):
		var key = keys[i]
		if dict.has(key) && dict[key] is Dictionary: dict = dict[key]
		else: return false
	return true
func updateDict(base:Dictionary,update:Dictionary,recursive:bool=false) -> Dictionary:#updates values from update
	for key in update:
		if base.has(key):
			if base[key] is Dictionary && update[key] is Dictionary: base[key] = updateDict(base[key],update[key])
			else: base[key] = update[key]
	return base
func extendDict(base:Dictionary,extension:Dictionary,recursive:bool=false) -> Dictionary:#adds new values of new keys from extension
	for key in extension:
		if !base.has(key): base[key] = extension[key]
		elif recursive && base[key] is Dictionary && extension[key] is Dictionary: base[key] = extendDict(base[key],extension[key],true)
	return base
func buildPath(prefix:String,specsList:Array,fileName:String,suffix:String) -> String:#builds a path with given values
	var specs=""
	for spec in specsList: if spec!="": specs+=spec+"/"
	return prefix+specs+fileName+suffix #constructs a path using args
func getFilename(path:String,omitExtension:bool=true)->String:
	path = path.get_file()
	if !omitExtension: return path
	for i in range(len(path)-2,-1,-1):
		if path.substr(i,1) == ".": path = path.left(i)
	return path #gets the name of the file from a path
func removeExtension(path:String) -> String:
	for i in range(len(path)-2,-1,-1): if path.substr(i,1) == ".": return path.left(i)
	return path
func getFilesInFolder(path:String,suffix:String="",clearExtraSuffixes:bool=true):
	var files = []
	var dir = DirAccess.open(path)
	if !dir: return []
	dir.list_dir_begin() # TODOConverter3To4 fill missing arguments https://github.com/godotengine/godot/pull/40547
	var file = dir.get_next()
	while file != '':
		if clearExtraSuffixes: for i in file.count(".")-1: file = removeExtension(file)
		if file.ends_with(suffix) && !(file in files): files.append(file)
		file = dir.get_next()
	return files
func isAreaOverlappingWith(area:Area2D,group:String,type:String="all"):
	var r = false
	if type=="all" || type == "area":
		var overlaps = area.get_overlapping_areas()
		for overlap in overlaps: if overlap.is_in_group(group): r = true
	if type=="all" || type == "body":
		var overlaps = area.get_overlapping_bodies()
		for overlap in overlaps: if overlap.is_in_group(group): r = true
	return r
func isBodyCollidingWith(body:CharacterBody2D,group:String):
	for i in body.get_slide_collision_count():
		if group in body.get_slide_collision(i).get_groups():
			return true
	return false
func isAnimationFinished(animatedSprite:AnimatedSprite2D,anim:String): #i.e. on last frame & not playing
	return animatedSprite.animation == anim\
	&& animatedSprite.frame == animatedSprite.sprite_frames.get_frame_count(anim) - 1\
	&& !animatedSprite.is_playing()
