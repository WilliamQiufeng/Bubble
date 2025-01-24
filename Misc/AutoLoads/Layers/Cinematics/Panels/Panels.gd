extends Node

var panel = preload("Panel.tscn")

func displayPanel(panelTexture,offset:Vector2,direction:Vector2,hold:float=1,shake:int=0,scale:int=4,playAudio:bool=true):
	var p = panel.instantiate()
	if panelTexture is String: p.texture = load(panelTexture)
	else: p.texture = panelTexture
	p.defaultOffset = offset
	p.direction = direction
	p.hold = hold
	p.shake = shake
	p.process_mode = PROCESS_MODE_ALWAYS
	T.addToNoTimeZone(p)
	p.defaultScale = scale
	$Control.add_child(p)
	if playAudio: p.get_node("PanelPlayer").play()
	return p
	
