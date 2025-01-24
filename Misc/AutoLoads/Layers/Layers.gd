extends Node2D

@onready var layerN100:CanvasLayer = $LayerN100
@onready var layer5:CanvasLayer = $Layer5
@onready var layer10:CanvasLayer = $Layer10
@onready var layer15:CanvasLayer = $Layer15

#LayerN100
@onready var sky:Node2D = $LayerN100/Sky
#Layer 5
@onready var hud:Node2D = $Layer5/Hud
@onready var interactionHints:Node2D = $Layer5/InteractionHints
@onready var cinematicBars:Node2D = $Layer5/CinematicBars
@onready var dialogueBox:DialogueBox = $Layer5/DialogueBox
@onready var inventory:Node2D = $Layer5/Inventory
@onready var toDoList:Node2D = $Layer5/ToDoList
#Layer 10
@onready var panels:Node2D = $Layer10/Panels
@onready var canvases:Node2D = $Layer10/Canvases
#Layer 15
@onready var transitions:Node2D = $Layer15/Transitions
@onready var pauseMenu:Node2D = $Layer15/PauseMenu

func resetAutoLoad(): #REQ
	return

func _ready() -> void: pass

func _physics_process(delta):
	
	if len(alertQueue)>0 && !alerting:
		alerting = true
		alertQueue[0][1].add_child(alertQueue[0][0])
		alertQueue.pop_front()

const alertBox:PackedScene = preload("AlertBox/AlertBox.tscn")
var alertQueue:Array = [] #[ [alertBox, parentNode] ]
var alerting:bool = false
func alert(message:String,canCancel:bool,parent:Node = layer10) -> Node2D:
	var ab:Node2D = alertBox.instantiate()
	ab.message = message
	ab.canCancel = canCancel
	if alerting:
		alertQueue.append([ab,parent])
	else:
		alerting = true
		parent.add_child(ab)
	return ab

func displayPanel(panelTexture,offset:Vector2,direction:Vector2,hold:float=1,shake:int=0,scale:int=4):
	panels.displayPanel(panelTexture,offset,direction,hold,shake,scale)
