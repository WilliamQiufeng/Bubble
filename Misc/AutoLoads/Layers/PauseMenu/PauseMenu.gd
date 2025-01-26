extends Node2D

var ap:AnimationPlayer# = $AnimationPlayer
var content:Node2D

var contentScene:PackedScene = preload("Content.tscn")

var pausing = false
var selectIndex = 0

func _ready():
	process_mode = PROCESS_MODE_ALWAYS
	T.addToNoTimeZone(self)

func _process(delta):
	if G.justPressed("escape") && !Scenes.switchingScene:
		if pausing: unpause()
		elif !is_instance_valid(content): pause()

func pause():
	content = contentScene.instantiate()
	add_child(content)
	ap = content.get_node("AnimationPlayer")
	
	T.pauseGame(self)
	pausing = true
	Focus.addFocus(self)
	selectIndex = 0
	

func unpause():
	ap.call_deferred("play","show",-1,-1,true)
	await ap.animation_finished
	T.resumeGame(self)
	pausing = false
	Focus.removeFocus(self)
	content.queue_free()
