extends Node

var bgmOverride:String = ""

var currentScene:Node2D = null
var targetScene:Node2D = null
var switchingScene:bool = false
var queue:Array = []

var defaultTransitionData:Dictionary = {
	"transition":"fade",
	"revealTransition":"same",
	"speed":1,
	"intervalS":0,
	"revealSpeed":1,
	"grabFocus":true,
	"releaseFocus":true,
	#"callLoad":true,
	#"callSave":true
}
var transitionData:Dictionary = defaultTransitionData

var saved_scenes:Array = ["bgmOverride"]

func resetAutoLoad():
	bgmOverride = ""

signal sceneExit
signal sceneEntered
signal sceneSwitched

func _ready():
	currentScene = getCurrentScene()

func _physics_process(delta):
	if len(queue)>0 && !switchingScene:
		switchScene(queue[0][0],queue[0][1],false)
		queue.pop_front()
	

#switches scenes
func switchScene(scene,newTransitionData:Dictionary={},queueIfSwitching:bool=false):
	G.diagnose()
	if switchingScene:
		if queueIfSwitching:
			queue.append([scene,newTransitionData])
			G.logMessage("Switch scene: Switch scene queued. Queue: "+str(queue))
		return
	G.logMessage("Switch scene: Switch scene to "+str(scene)+" with data "+str(newTransitionData)+" (not queued)")
	switchingScene = true
	if scene is Node2D:
		targetScene = scene.duplicate()
		scene.free()
		G.logMessage("Switch scene: Scene is Node2D; duplicated and freed",1)
	if scene is String:
		var packedScene = load(scene)
		assert(packedScene!=null,'Scene "'+scene+'" does not exist in filesystem')
		targetScene = packedScene.instantiate()
	transitionData = defaultTransitionData.duplicate(true)
	G.updateDict(transitionData,newTransitionData)
#	Focus.setQueue([self]) #grabs the focus
	if transitionData.grabFocus: Focus.addFocus(self)
	if transitionData.transition != "": await Layers.transitions.play(transitionData.transition,transitionData.speed).animation_finished
	if !G.nearEqual(transitionData.intervalS): await G.setTimer(transitionData.intervalS).timeout
	call_deferred("_deferredSwitchScene",targetScene)
	G.diagnose()

func _deferredSwitchScene(sceneInstance):
	G.diagnose()
	if sceneInstance == null:
		G.logMessage("Switch scene deferred: sceneInstance == null",1)
		return
	G.logMessage("Switch scene deferred",1)
	G.notify("exitScene",{"callSave":transitionData.callSave})
	G.emitAndLogMessage(sceneExit,1)
	#take down the current scene
	G.allNodes.clear()
	G.characters.clear()
	currentScene.free()
	currentScene = sceneInstance
	G.allNodes = G.getAllNodes()
	#load the new scene
	get_tree().set_current_scene(currentScene)
	get_tree().get_root().add_child(currentScene)
	
	G.allNodes.append_array(G.getSubNodes(currentScene))
	G.updateVars()
	#call nodes to ready up for scene
	sceneEntered.emit()
	G.call_deferred("notify","enteredScene",{"callLoad":transitionData.callLoad})
	if transitionData.transition != "":
		if transitionData.revealTransition == "same": transitionData.revealTransition = transitionData.transition
		await Layers.transitions.play(transitionData.revealTransition,-transitionData.revealSpeed).animation_finished
	if transitionData.releaseFocus: Focus.removeFocus(self) #only remove self to not interfere
	switchingScene = false
	sceneSwitched.emit()
	G.diagnose()
	return currentScene

func isCurrentScenePath(scenePath:String):
	assert(ResourceLoader.exists(scenePath),"Invalid scenePath: "+scenePath+" Path deprecated?")
	return scenePath == currentScene.scene_file_path
func getCurrentScenePath() -> String:
	return currentScene.scene_file_path
func getCurrentScene() -> Node2D:
	var root = get_tree().get_root()
	return root.get_child(root.get_child_count() - 1)
