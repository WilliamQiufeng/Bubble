extends Node2D

var active:bool = false

const CONTENT_SCENE:PackedScene = preload("Content.tscn")

#This node listens to inputs, it instantiates via activate() the actual content on some input
#on some other input, it frees the content via deactivate()

func _physics_process(delta):
	if G.justPressed("menu2"):
		if !active && Focus.isFocused(G.player):
			activate()
		elif active && Focus.isFocused(self):
			assert(is_instance_valid(get_child(0)),"Tried deactivating invalid content")
			deactivate()

func activate():
	if !G.playerInSceneDeferred(): return
	add_child(CONTENT_SCENE.instantiate())
	active = true
	Focus.addFocus(self)
		
func deactivate():
	active = false
	Focus.removeFocus(self)
	var content:Node2D = get_child(0)
	if is_instance_valid(content):
		content.targetAlphaC = 0
		Audio.playEffect(preload("res://Assets/Audio/Effects/ShakeLow.wav"))

func abort():
	deactivate()
	G.freeChildren(self)
