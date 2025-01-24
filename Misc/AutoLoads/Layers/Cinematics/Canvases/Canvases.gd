extends Node2D

@onready var sprite:Sprite2D = $Canvas
@onready var underlay:ColorRect = $Underlay
@onready var textLabel:RichTextLabel = $RichTextLabel

var queue = []
var queueIndex = 0

var canvasPosition:Vector2 = Vector2(700,400)
var textPositionY:float = 620
var textInterval:int = 2
var textCd:int = 0
var displaying:bool = false #FOR SYNC


#var defaultArgs = {
#	"image":null,
#	"transition":"fade",
#	"revealTransition":"same",
#	"transitionSpeed":1,
#	"revealTransitionSpeed":1,
#	"interval":0.5
#}

signal endCanvasDisplay
signal canvasDisplay

func notif_enteredScene(msg):
	pass

func _ready():
	G.followNotification(notif_enteredScene,"enteredScene")
	hide()

func _physics_process(delta):
	if textCd<=0 && T.timer%textInterval==0 && textLabel.visible_characters<textLabel.text.length(): textLabel.visible_characters += 1
	textCd = G.reach0(textCd,1)

#add a canvas with image "" or "none" or null to end the sequence

func displayQueue(grabFocus:bool=true) -> Node2D:
	assert(len(queue)>0, "No canvases in queue")
	assert(queueIndex<len(queue),"Queue index out of range, no end canvas?")
	display(queue[queueIndex],grabFocus)
	queueIndex += 1
	return self

func endDisplay(clearQueue:bool=true):
	displaying = false
	endCanvasDisplay.emit()
	if clearQueue:
		queue.clear()
		queueIndex = 0
	Focus.removeFocus(self)
	hide()
	

func addCanvas(args:Dictionary):
	var c = RefCanvas.new()
	G.setProperties(c,args,true)
	queue.append(c)
func addEndCanvas(): addCanvas({"image":"end"})
func addBlankCanvas(): addCanvas({"image":"blank"})

func display(canvas:RefCanvas,grabFocus:bool):
	if grabFocus: Focus.addFocus(self)
	if canvas.transition != "": await Layers.transitions.play(canvas.transition,canvas.transitionSpeed).animation_finished
	await G.setTimer(canvas.interval).timeout
	sprite.position = canvasPosition
	textLabel.position.y = textPositionY
	displaying = true
	if canvas.image is String:
		if canvas.image == "blank": sprite.hide()
		elif canvas.image == "end":
			return endDisplay()
		else: assert(false,"Invalid canvas string")
	elif canvas.image is Texture:
		sprite.texture = canvas.image
		sprite.show()
		show()
		canvasDisplay.emit()
	textLabel.text = "[center]"+canvas.text
	textLabel.set_visible_characters(0)
	textCd = 60 #delay for displaying text
	if canvas.transition != "": 
		if canvas.revealTransition == "same": canvas.revealTransition = canvas.transition
		await Layers.transitions.play(canvas.revealTransition,-canvas.revealTransitionSpeed).animation_finished
	if canvas.echoTime>0:
		await G.setTimer(canvas.echoTime).timeout
		if canvas.displayAfterEcho: displayQueue(false)

func setUndelayColor(color:Color):
	underlay.modulate = color
	
