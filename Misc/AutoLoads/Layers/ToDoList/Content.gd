extends Node2D

@onready var objectiveLabel = $ObjectiveLabel
@onready var clockLabel = $ClockLabel
@onready var buttonLeft = $ButtonLeft
@onready var buttonRight = $ButtonRight

var targetAlphaC:float = 1

var page:int = 0
var list:Array = []
var hiddenList:Array = []


func _ready():
	modulate.a = 0
	updateList()

func _physics_process(delta):
	modulate.a = move_toward(modulate.a,targetAlphaC,0.1)
	if G.nearEqual(modulate.a): queue_free()
	
	buttonLeft.modulate.a = 0.3
	buttonRight.modulate.a = 0.3
	
	updateList()
	if len(list)<=0:
		for q in hiddenList:
			if !Story.blockers.has(q.questName): continue
			var blocker = Story.blockers[q.questName]
			if blocker[0]+blocker[1] - (Story.date+Story.time) < 30:
				objectiveLabel.set_text("I'm not tired at all, maybe I should take a walk...")
				clockLabel.set_text("[center]FATE")
				return
		objectiveLabel.set_text("There is nothing more to do right now, maybe I should go to sleep...")
		clockLabel.set_text("[center]CLEAR")
		return
	if page < len(list):
		objectiveLabel.set_text(list[page].objective)
		var q = list[page]
		if Story.blockers.has(q.questName):
			var blocker = Story.blockers[q.questName]
			if blocker[0]+blocker[1] - (Story.date+Story.time) < 1:
				var clock = Story.formatClock(Story.time2clock(Story.blockers[q.questName][1]))
				clockLabel.set_text("[center]"+clock)
			else: clockLabel.set_text("[center]TO DO")
		else: clockLabel.set_text("[center]TO DO")
	else:
		page = len(list)-1
	if page>0:
		buttonLeft.modulate.a = 1
		if G.justPressed("left"): page-=1
	elif page+1<len(list):
		buttonRight.modulate.a = 1
		if G.justPressed("right"): page+=1
		
func updateList():
	list.clear()
	for qn in Story.quests:
		if Story.quests[qn].objective != "": list.append(Story.quests[qn])
		else: hiddenList.append(Story.quests[qn])
