extends Node2D

var ap:AnimationPlayer# = $AnimationPlayer
var pointer:Node2D# = $Pointer
var content:Node2D

var contentScene:PackedScene = preload("Content.tscn")

var pausing = false
var selectIndex = 0

func _ready():
	process_mode = PROCESS_MODE_ALWAYS
	T.addToNoTimeZone(self)

func _process(delta):
	if true: #WORK
		if G.justPressed("escape") && !pausing && !Scenes.switchingScene && !is_instance_valid(content):
			pause()
		if !is_instance_valid(content) || !Focus.isFocused(self): return
		if pausing:
			if G.justPressed("up"):
				if selectIndex>0: selectIndex-=1
			elif G.justPressed("down"):
				if selectIndex<2: selectIndex+=1
			elif G.justPressed("confirm"):
				match selectIndex:
					0: unpause()
					1:
						var ab = Layers.alert("Are you sure? Unsaved progress will be lost!",true,Layers.layer15)
						await ab.alerted
						if ab.chosen == "confirm":
							unpause()
							Scenes.switchToStartMenu()
							#uncomment if relaunch instead of exit to menu
#							OS.execute(OS.get_executable_path(), [], false)
#							OS.kill(OS.get_process_id())
					2:
						var ab = Layers.alert("Are you sure? Unsaved progress will be lost!",true,Layers.layer15)
						await ab.alerted
						if ab.chosen == "confirm":
							get_tree().quit()
				$Content/ShakeQuickPlayer.play()
		pointer.lerpPositionY = 305+100*selectIndex

func pause():
	content = contentScene.instantiate()
	add_child(content)
	ap = content.get_node("AnimationPlayer")
	pointer = content.get_node("Pointer")
	
	T.pauseGame(self)
	pausing = true
	Focus.addFocus(self)
	pointer.lerpPositionX = 370
	selectIndex = 0
	

func unpause():
	pointer.lerpPositionX = -100
	ap.call_deferred("play","show",-1,-1,true)
	await ap.animation_finished
	T.resumeGame(self)
	pausing = false
	Focus.removeFocus(self)
	content.queue_free()
