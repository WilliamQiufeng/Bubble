extends Node

var gamePaused:bool = false

var timeScalePrecision = 0.001 #timeScales can only be in steps of this
var worldTimeScale:float = 1 #the speed of in-world time
var _lastGameTimeScale:float = 1 #the gameTimeScale from last frame, used to detect changes
var gameTimeScale:float = 1 #the time scale the game runs at, scales timeScale
var _lastProductTimeScale:float = 1 #the worldTimeScale from last frame, used to detect changes
var productTimeScale:float = 1 #time perceived by the player, = world t. * game t.

var timer:int = 0 #absolute timer unaffected by anything
var floatWorldTimer:float = 0 #raw timer increasing in steps of world time scale
var worldTimer:int = 0 #floored float preceived timer, the timer perceived by world
var floatGameTimer:float = 0 #raw timer increasing in steps of game time scale
var gameTimer:int = 0 #floored float game timer, the absolute time perceived
var floatProductTimer:float = 0 #raw timer increasing in steps of world time scale*game time scale
var productTimer:int = 0 #floored float product timer, the timer perceived by world

#var world:Array[Obj] = [] #collection of objects in the world time zone
var gameTimeZone:Array[Object] = [] #collection of objects in the game time zone
var noTimeZone:Array[Object] = [] #collection of objects in no time zone

var timers:Array[RefTimer] = []

var unsaved_vars:Array = ["gamePaused"]
#signal worldTimeScaleChanged(changePercentage)

const TZ_STR:Array[String] = ["none","world","game"]
enum TZ {
	NONE=0,
	WORLD=1,
	GAME=2
}

func resetAutoLoad():
	timeScalePrecision = 0.001
	worldTimeScale = 1
	gameTimeScale = 1
	floatWorldTimer = 0
	worldTimer = 0
	floatGameTimer = 0
	gameTimer = 0
	timers.clear()
	

func notif_exitScene(msg):
	for i in range(len(timers)-1,-1,-1):
		if !timers[i].persistent:
			timers[i].disabled = true
			timers.remove_at(i)


func _ready():
	Engine.time_scale = 1
	process_mode = Node.PROCESS_MODE_ALWAYS
	T.addToNoTimeZone(self)
	G.followNotification(notif_exitScene,"exitScene")
	G.callOnAllNodes.append(
		func (n:Node) -> void:
			#for performance
			if timer % 5 == 0 && n.get_class() in [
					"AnimationPlayer", "AnimatedSprite2D", "GPUParticles2D", "CPUParticles2D",
					"CharacterBody2D"
				]:
				var tz:int = getTimeZone(n)
				if tz == TZ.NONE: return
				if tz == TZ.GAME:
					updateNode(n,gameTimeScale)
					if _lastGameTimeScale != gameTimeScale:
						if n.is_in_group("kinematicPhysics"):
							if !G.nearEqual(gameTimeScale*_lastGameTimeScale):
								n.velocity*=gameTimeScale/_lastGameTimeScale
				else: #world time zone, i.e. affected by productTimeScale
					updateNode(n,productTimeScale)
					if _lastProductTimeScale != productTimeScale:
						if n.is_in_group("kinematicPhysics"):
							if !G.nearEqual(productTimeScale*_lastProductTimeScale):
								n.velocity*=productTimeScale/_lastProductTimeScale
			_lastProductTimeScale = productTimeScale
			_lastGameTimeScale = gameTimeScale
	)


func _physics_process(delta):
	G.diagnose()
	timer+=1
	
	worldTimeScale = snapped(worldTimeScale,timeScalePrecision)
	floatWorldTimer+=worldTimeScale
	worldTimer = floor(floatWorldTimer)

	gameTimeScale = snapped(gameTimeScale,timeScalePrecision)
	floatGameTimer+=gameTimeScale
	gameTimer = floor(floatGameTimer)

	productTimeScale = worldTimeScale*gameTimeScale
	floatProductTimer+=productTimeScale
	productTimer = floor(floatProductTimer)

	#WORRY time
#	if gameTimeScale == 0: Engine.time_scale = 0
#	else: Engine.time_scale = gameTimeScale

	for i in range(len(gameTimeZone)-1,-1,-1):
		if !is_instance_valid(gameTimeZone[i]):
			gameTimeZone.remove_at(i)
	for i in range(len(noTimeZone)-1,-1,-1):
		if !is_instance_valid(noTimeZone[i]):
			noTimeZone.remove_at(i)
	
	for i in range(len(timers)-1,-1,-1):
		if !timers[i].isValid():
			timers.remove_at(i)
			continue
		timers[i].fixedProcess()
	
	for i in range(len(pauseList)-1,-1,-1): if !is_instance_valid(pauseList[i]): pauseList.remove_at(i)
	
	G.diagnose()
	
var pauseList:Array = []
var savedGameTimeScale = gameTimeScale
func pauseGame(caller:Object) -> void:
	if caller in pauseList: return
	pauseList.append(caller)
	if gamePaused: return
	savedGameTimeScale = gameTimeScale
	gameTimeScale = 0
	gamePaused = true
#	if pauseTree: G.pauseTree(true)
func resumeGame(caller:Object) -> void:
	if !gamePaused: return
	if !(caller in pauseList): return
	pauseList.erase(caller)
	if len(pauseList)>0: return
	gameTimeScale = savedGameTimeScale
	gamePaused = false
#	if resumeTree: G.pauseTree(false)
func setTimer(timeF,persistent:bool=false)->Object: return createTimer(timeF,true,T.TZ.NONE,persistent)
func createTimer(timeF:int,oneshot:bool=true,timeZone:int=T.TZ.WORLD,persistent:bool=false)->Object:
	var t:RefTimer = RefTimer.new()
	t.defaultTimeF = timeF
	t.timeF = timeF
	t.oneshot = oneshot
	t.timeZone = timeZone
	timers.append(t)
	return t

func createAutocallTimer(time:int,callable:Callable,args:Array=[],interval:int=1,timeZone:int=T.TZ.WORLD):
	var t:RefTimer = createTimer(time,true,timeZone)
	t.autocallCallable = callable
	t.autocallInterval = interval
	t.autocallArgs = args
	return t

#func canMove(obj:Object):
	#if isUpdateFree(obj): return true
	#if paused(): return false
	#if stopped(): return isWorldFree(obj)
	#return true
#func isFreeInWorld(obj:Object):
#	if obj is Node: return G.isUnderGroup(obj,"updateFree")||isFreeInWorld(obj)
#	return G.checkAtt(obj,"updateFree",true)||isFreeInWorld(obj)
#func isFreeInWorld(obj:Object):
	#if obj is Node:
		#var gs:Array = G.getGroupsAbove(obj)
##		testFreeInWorld(G.isUnderGroup(obj,"worldFree"),G.isUnderGroup(obj,"heavenFree"))
		#return testFreeInWorld("worldFree" in gs,"heavenFree" in gs,"updateFree" in gs)
	#return testFreeInWorld(G.checkAtt(obj,"worldFree",true),G.checkAtt(obj,"heavenFree",true),G.checkAtt(obj,"updateFree",true))
#func testFreeInWorld(worldFree:bool,heavenFree:bool,updateFree:bool):
	#if updateFree: return true
	#return (worldFree && stopped()) || (heavenFree && !stopped()) || G.nearEqual(worldTimeScale,1.0)
#func isWorldFree(obj:Object):
	#if obj is Node: return G.isUnderGroup(obj,"worldFree")# obj.is_in_group("worldFree")
	#return G.checkAtt(obj,"worldFree",true)
#func isHeavenFree(obj:Object):
	#if obj is Node: return G.isUnderGroup(obj,"heavenFree") #obj.is_in_group("heavenFree")
	#return G.checkAtt(obj,"heavenFree",true)
#func isUpdateFree(obj:Object):
	#if obj is Node: return G.isUnderGroup(obj,"updateFree") #obj.is_in_group("heavenFree")
	#return G.checkAtt(obj,"updateFree",true)

func stopped() -> bool:
	return G.nearEqual(worldTimeScale)
func paused() -> bool:
	return G.nearEqual(gameTimeScale)# || get_tree().paused

func addToTimeZone(obj:Object,tz:int):
	match tz:
		TZ.NONE: addToNoTimeZone(obj)
		TZ.GAME: addToGameTimeZone(obj)
	#world time zone is default
	assert(false,"World time zone is default, so no need to add")

func addToGameTimeZone(obj:Object) -> void:
	gameTimeZone.erase(obj)
	noTimeZone.erase(obj)
	gameTimeZone.append(obj)
func addToNoTimeZone(obj:Object) -> void:
	gameTimeZone.erase(obj)
	noTimeZone.erase(obj)
	noTimeZone.append(obj)

func canAdvance(obj:Object,timeZone:int=-1) -> bool:
	if timeZone == -1: timeZone = getTimeZone(obj)
#	if !canMove(isWorldFree(obj),isUpdateFree(obj)): return false
	var objectTimeScale = getTimeScale(timeZone)
	var objectFloatTimer = getFloatTimer(timeZone)
	return floor(objectFloatTimer-objectTimeScale)<floor(objectFloatTimer)# && !stopped()
#	return floor(floatProductTimer-productTimeScale)<floor(floatProductTimer)# && !stopped()
func getTimeZone(obj:Object) -> int:
	if !(obj is Node):
		return TZ.NONE if obj in noTimeZone else (TZ.GAME if obj in gameTimeZone else TZ.WORLD)
	# upper time zones have higher priority
	# e.g. if n1 is a desc of both n2 in game tz and n3 in no tz, n1 is in no tz rather than game tz
	for o in noTimeZone:
		if !(is_instance_valid(o) && o is Node): continue
		if o == obj || o.is_ancestor_of(obj): return TZ.NONE
	for o in gameTimeZone: # so assume
		if !(is_instance_valid(o) && o is Node): continue
		if o == obj || o.is_ancestor_of(obj): return TZ.GAME
	return TZ.WORLD

func getTimeScale(subject) -> float: #time scale relative to Engine
	var timeZone:int = subject if (typeof(subject) == TYPE_INT) else getTimeZone(subject)
	match timeZone:
		TZ.NONE: return 1.0
		TZ.WORLD: return productTimeScale
		TZ.GAME: return gameTimeScale
	assert(false,"Invalid time zone: "+TZ_STR[timeZone])
	return -1.0
func getTimer(subject) -> int: #the absolute timer of the obj
	var timeZone:int = subject if (typeof(subject) == TYPE_INT) else getTimeZone(subject)
	match timeZone:
		TZ.NONE: return timer
		TZ.GAME: return gameTimer
		TZ.WORLD: return productTimer
	assert(false,"Invalid time zone: "+TZ_STR[timeZone])
	return -1
func getFloatTimer(subject) -> float: #the absolute float timer of the obj
	var timeZone:int = subject if (typeof(subject) == TYPE_INT) else getTimeZone(subject)
	match timeZone:
		TZ.NONE: return float(timer)
		TZ.GAME: return floatGameTimer
		TZ.WORLD: return floatProductTimer
	assert(false,"Invalid time zone: "+TZ_STR[timeZone])
	return -1.0

#convenient local functions
func updateNode(n:Node,newTimeScale:float) -> void:
	if n is AnimationPlayer || n is AnimatedSprite2D || n is GPUParticles2D || n is CPUParticles2D:
		n.speed_scale = newTimeScale
