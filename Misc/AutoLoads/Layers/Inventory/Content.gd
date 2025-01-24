extends Node2D

@onready var page:Node2D = $Page
@onready var itemsNode:Node2D = $Items
@onready var itemNameLabel:RichTextLabel = $ItemName/RichTextLabel
@onready var descriptionLabel:RichTextLabel = $Description/RichTextLabel
@onready var selectionFrame:Node2D = $SelectionFrame
@onready var confirmButtonGlow:Sprite2D = $ConfirmButtonGlow
@onready var cancelButtonGlow:Sprite2D = $CancelButtonGlow

var lerpPosition = Vector2.ZERO
var active = false
var actionState = "select"
var lastDiscardMessage = ""

var selectedRow = 0
var selectedColumn = 0


func _ready():
	updateSprites()

	

func _physics_process(delta):
	if !G.playerInScene():
		return
	position = lerp(position,lerpPosition,0.2)
	position = G.tolerate2(position,lerpPosition)
	if position.x == 520:
		queue_free()
	
	if !Focus.isFocused(Layers.inventory): return
	var index = getSelectIndex()
	
	if actionState in ["select","postDiscard"]:
		if G.justPressed("up"):
			if selectedRow > 0: selectedRow -= 1
			actionState = "select" #if post discarding, switch to select
		elif G.justPressed("down"):
			if selectedRow < 2: selectedRow += 1
			actionState = "select" #if post discarding, switch to select
		elif G.justPressed("left"):
			if selectedColumn > 0: selectedColumn -= 1
			actionState = "select" #if post discarding, switch to select
		elif G.justPressed("right"):
			if selectedColumn < 3: selectedColumn += 1
			actionState = "select" #if post discarding, switch to select
		index = getSelectIndex()
		if actionState == "postDiscard": #post discard messageDisplay
			if lastDiscardMessage == "": descriptionLabel.set_text("[center]The item was discarded")
			else: descriptionLabel.set_text("[center]"+lastDiscardMessage)
			if G.justPressedAndReleased("confirm")||G.justPressedAndReleased("cancel"): actionState = "select"
		else: #actionState == "select"
			confirmButtonGlow.visible = int(G.pressed("confirm"))
			cancelButtonGlow.visible = int(G.pressed("cancel"))
			if len(G.player.inventory) > index: #set normal item description
				descriptionLabel.set_text("[center]"+G.player.inventory[index].description)
				if G.justPressedAndReleased("confirm"):
					actionState = "use"
					$ConfirmPlayer.play()
				elif G.justPressedAndReleased("cancel"):
					actionState = "discard"
					$CancelPlayer.play()
			else:
				descriptionLabel.set_text("")
		
	elif actionState == "use":
		descriptionLabel.set_text("[center]Use this item?")
		if G.justPressedAndReleased("confirm"):
			if G.player.inventory[index].use(G.player):
				G.player.inventory.remove_at(index)
				$UsePlayer.play()
			else:
				$ShakeLowPlayer.play()
			actionState = "select"
			updateSprites()
		elif G.justPressedAndReleased("cancel"):
			actionState = "select"
			$CancelPlayer.play()
		
	elif actionState == "discard":
		descriptionLabel.set_text("[center]Discard this item?")
		if G.justPressedAndReleased("confirm"):
			lastDiscardMessage = G.player.inventory[index].discardMessage
			if G.player.inventory[index].discard(G.player): G.player.inventory.remove_at(index)
			actionState = "postDiscard"
			updateSprites()
			$ConfirmPlayer.play()
		elif G.justPressedAndReleased("cancel"):
			actionState = "select"
			$CancelPlayer.play()
		
	#display the item name under most conditions
	if len(G.player.inventory) > index && actionState != "postDiscard":
		#check whether to overwrite itemName with displayName
		if G.player.inventory[index].displayName == "same": itemNameLabel.set_text("[center]"+G.player.inventory[index].itemName.capitalize())
		else: itemNameLabel.set_text("[center]"+G.player.inventory[index].displayName)
	else: itemNameLabel.set_text("")
	
		
	selectionFrame.position = lerp(selectionFrame.position,Vector2(1072+selectedColumn*88,456+selectedRow*88),0.4)
		


func updateSprites(inventory = G.player.inventory):
	for node in itemsNode.get_children():
		node.queue_free()
	for i in len(inventory):
		var sprite = Sprite2D.new()
		itemsNode.add_child(sprite)
		sprite.scale = G.v2(4)
		var rowNumber = floor(i/4)
		var columnNumber = i%4
		sprite.position = Vector2(1072+columnNumber*88,456+rowNumber*88)
		sprite.texture = inventory[i].texture

func getSelectIndex():
	return selectedRow*4+selectedColumn
