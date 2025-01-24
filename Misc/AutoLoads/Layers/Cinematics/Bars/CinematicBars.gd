extends Node

#cinematic bars
var targetRaiseSize:float = 0
var targetCloseSize:float = 0

@onready var maxX = get_viewport().size.x/2
@onready var maxY = get_viewport().size.y/2

func _ready():
	add_to_group("cinematicBars")

func _process(delta):
	updateBars()


#setters
func setSize(size:Vector2,instant:bool=false):
	targetCloseSize = size.x
	targetRaiseSize = size.y
	if instant:
		letterBars().size = size.y
		pillarBars().size = size.x

#_process functions
func updateBars():
	#continues to raise bars until target sizes
	letterBars().size.y = lerp(letterBars().size.y,targetRaiseSize,0.15)
	letterBars().size.y = G.tolerate(letterBars().size.y,targetRaiseSize,0.5)
	pillarBars().size.x = lerp(pillarBars().size.x,targetCloseSize,0.15)
	pillarBars().size.x = G.tolerate(pillarBars().size.x,targetCloseSize,0.5)
#	closeBars((targetCloseSize-pillarBars().rect_size.x)*0.15)
#	raiseBars((targetRaiseSize-letterBars().rect_size.y)*0.15)
	letterBars(1).size.y = letterBars().size.y
	pillarBars(1).size.x = pillarBars().size.x



#raises up and down bars by an amount
func raiseBars(amount):
	var bar = letterBars()
	bar.size.y += amount
#	if bar.rect_size.y>maxY || abs(targetRaiseSize-bar.rect_size.y)<targetRaiseSize*0.005:
#		bar.rect_size.y=targetRaiseSize
#closes left and right bars by an amount
func closeBars(amount):
	var bar = pillarBars()
	bar.size.x += amount
#	if bar.rect_size.x>maxX || abs(targetCloseSize-bar.rect_size.x)<targetCloseSize*0.005:
#		bar.rect_size.x=targetCloseSize

#getters
func pillarBars(i=0):
	if i <0: return $PillarBars.get_children()
	return $PillarBars.get_children()[i]
func letterBars(i=0):
	if i <0: return $LetterBars.get_children()
	return $LetterBars.get_children()[i]
