extends Node

func notif_exitScene(msg):
	pass

signal dateAdvanced

func resetAutoLoad():
	area = "ns4"
	resetDateTimeVars()
	resetHistory()
	resetCutsceneVars()
	

var area:String = "ns4"

func _ready():
	process_mode = PROCESS_MODE_ALWAYS
	T.addToNoTimeZone(self)
	G.followNotification(notif_exitScene,"exitScene")
	resetAutoLoad()
	Layers.sky.updateSkyBackground()

func _physics_process(delta):
	time = 0
	G.diagnose()
	if T.canAdvance(self,T.TZ.WORLD) && canAdvanceTime:
		assert(date>=0,"Date cannot be negative")
		assert(time>=0&&time<1,"Time out of range [0,1)")
		#if T.productTimer % 2 == 0:
		advanceTime(mins2time(0.02))
		#if G.DEBUGGING && T.productTimer % 5==0:
			#advanceTime(2)
	
	if cutsceneTimer>=0:
		cutsceneTimer+=1
	G.diagnose()

func resetDateTimeVars():
	canAdvanceTime = true
	timePaused = false
	time = clock2time([0,0])
	date = 0
	blockers.clear()
#date and time management
var canAdvanceTime:bool = true
var date:int = 0 #days
var time:float = clock2time([12,0])
var timePaused:bool = false
var blockers:Dictionary = { "testBlocker":[5,clock2time([24,0])] } #{ blockerName : [ date , time ] }

func addBlocker(blockerName:String,blockDate:int,blockTime:float,overwrite:bool=true):
	assert(blockDate>=0,"Date cannot be negative, blocker: "+blockerName)
	assert(G.inRange(blockTime,0,24*60-1),"Time out of range [0,24*60)")
	if !overwrite && blockers.has(blockerName): return
	blockers[blockerName] = [blockDate,blockTime]
func removeBlocker(blockerName:String): blockers.erase(blockerName)
func getTimeTillNextBlocker() -> float: #assume all blockers are in the future
	var minTime:float = INF
	for key in blockers:
		var b:Array = blockers[key]
		#get the time difference between dates,
		#reduce by time already passed (time), increase by blocker time into the day (b[1])
		var t:float = b[0]-date+b[1]-time
		if t < minTime: minTime = t
	return minTime
func advanceTime(amount:float,testOnly=false) -> bool: #return true if time actually advanced
	if timePaused: return false
	amount = min(amount,getTimeTillNextBlocker())
	if !testOnly: time += amount
	if time >= 1: #passing midnight
		time -= 1
		advanceDate()
	return G.sureGreater(amount)
func advanceDate():
	date+=1
	dateAdvanced.emit()
	G.notify("dateAdvanced")
func getClock() -> Array: return time2clock(time)
func formatClock(c:Array) -> String: return padTens(c[0])+":"+padTens(c[1])
func timeInRange(minClock,maxClock):
	minClock = clock2time(minClock)
	maxClock = clock2time(maxClock)
	if maxClock<minClock: return time < maxClock || time > minClock #warps around
	return G.inRange(time,minClock,maxClock)
func padTens(n:int):
	var r = str(n)
	return "0"+r if r.length()<=1 else r
func clock2time(c:Array[int]) -> float: return hours2time(c[0])+mins2time(c[1])
func time2clock(t:float): return [int(t*24),int(t*24*60)%60]
func hours2time(h:int) -> float: return h/float(24)
func mins2time(mins:float) -> float: return mins/float(24*60)

func resetHistory():
	history = [{ "eventName": "theBeginningOfHistory","IsSampleForTesting":true,"time":0}]
	
var history:Array[Dictionary] = [ #to keep track of previous facts
	{ #sample initial event
		"eventName": "theBeginningOfHistory",
		"isSampleForTesting":true,"day":0
	}
]
#history & events managing
func getFromHistory(eventName:String):
	for e in history: if e.eventName == eventName: return e
	assert(false,'Event "'+eventName+'" does not exist. Typo in name? Use if eventExists()?')
func existsInHistory(eventName:String) -> bool:
	for e in history: if e.eventName == eventName: return true
	return false
func addToHistory(eventName:String,eventData:Dictionary):
	assert(!eventData.has("eventName"),'Event data cannot have property "eventName"')
	history.append(G.extendDict(eventData,{"eventName":eventName}))

func resetCutsceneVars():
	inCutscene = false
	cutsceneTimer = -1
	currentCutscene = ""
	
var inCutscene:bool = false
var cutsceneTimer = -1 #unused
var currentCutscene = "" #unused
func startCutscene(raiseBars:bool=true,cutsceneName:String="none"):
	timePaused = true
	cutsceneTimer = 0
	currentCutscene = cutsceneName
	if raiseBars: Layers.cinematicBars.setSize(Vector2(0,120))
	Focus.addFocus(self)
	inCutscene = true
func endCutscene(lowerBars:bool=true):
	timePaused = false
	cutsceneTimer = -1
	currentCutscene = "none"
	if lowerBars: Layers.cinematicBars.setSize(Vector2(0,0))
	Focus.removeFocus(self)
	inCutscene = false
