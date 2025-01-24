extends Node2D


var active = false

var CONTENT_SCENE:PackedScene = preload("Content.tscn")

func _physics_process(delta):
	#leave room for closing animation by checking child count
	if G.justPressed("menu1"):
		if active && Focus.isFocused(self):
			Audio.playEffect(preload("res://Misc/Effects/ShakeLow.wav"))
			deactivate()
#		if Focus.isFocused(G.player) && !active:
#			activate()
#		elif active && Focus.isFocused(self):
#			deactivate()


func activate():
	if !G.playerInScene(): return
	add_child(CONTENT_SCENE.instantiate())
	active = true
	Focus.addFocus(self)

func deactivate():
	active = false
	Focus.removeFocus(self)
	if has_node("Content"): get_node("Content").lerpPosition.x = 520


func abort():
	deactivate()
	G.freeChildren(self)
