extends Node2D

signal alerted()


@onready var label:RichTextLabel = $RichTextLabel
@onready var ap:AnimationPlayer = $AnimationPlayer


var message:String = "Sample alert box"
var canCancel = true
var chosen = ""

func _ready():
	add_to_group("alertBox")
	T.addToNoTimeZone(self)
	Focus.addFocus(self)
	if !canCancel:
		$CancelButton.hide()
		$ConfirmButton.texture = preload("OkButton.png")
		$ConfirmButton.position.x=130
		$ConfirmButtonHighlight.position.x = $ConfirmButton.position.x
	label.text = "[center]"+message
	call_deferred("initialize")
	G.logMessage("AlertBox "+str(self)+" ready (message = \"" + message+"\"; canCancel = "+str(canCancel)+")")
	
func _physics_process(delta):
	if !Layers.alerting:
		assert(false,"Should not happen")
		queue_free() # should not trigger
	if chosen != "": return
	
	if !Focus.isFocused(self): return
	
	$ConfirmButtonHighlight.visible = G.pressed("confirm")
	$CancelButtonHighlight.visible = G.pressed("cancel") && canCancel
	if G.justPressedAndReleased("confirm"):
		chosen = "confirm"
		$ConfirmPlayer.play()
		finalize()
		G.logMessage("AlertBox "+str(self)+" confirmed")
	elif G.justPressedAndReleased("cancel") && canCancel:
		chosen = "cancel"
		$CancelPlayer.play()
		finalize()
		G.logMessage("AlertBox "+str(self)+" canceled")

func initialize():
	label.position.y = -50-label.get_content_height()/2
func finalize():
	alerted.emit()
	ap.play_backwards("load")
	await ap.animation_finished
	queue_free()
	Focus.removeFocus(self)
	Layers.alerting = false # allows the next alertBox in queue to display
