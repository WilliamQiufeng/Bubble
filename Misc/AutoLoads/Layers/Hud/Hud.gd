extends Node2D

@onready var hudArmedTop:Sprite2D = $HudArmedTop
@onready var energyBar:TextureProgressBar = $HudArmedTop/EnergyBar
@onready var resonanceBar:TextureProgressBar = $HudArmedTop/ResonanceBar
@onready var hudArmedBottom:Sprite2D = $HudArmedBottom
@onready var magazine:Node2D = $HudArmedBottom/Magazine
var ammoIcons:Array[Sprite2D] = []

@onready var hudUnarmed:Sprite2D = $HudUnarmed
@onready var clockPlate:Sprite2D = $HudUnarmed/ClockPlate
@onready var creditLabel:RichTextLabel = $HudUnarmed/CreditLabel
@onready var karmaLabel:RichTextLabel = $HudUnarmed/KarmaLabel

func _ready():
	visible = false
	await Scenes.currentSceneValidSignal()
	visible = Scenes.current().sceneType in ["world"]

func _physics_process(delta):
	if !visible: return
	if G.playerInSceneDeferred() && !Story.inCutscene:
		if G.player.is_in_group("combatant") && G.player.armed: #armed HUD
			hudArmedTop.position.y = lerp(hudArmedTop.position.y,0.0,0.4) #drop down from above
			hudArmedBottom.position.y = lerp(hudArmedBottom.position.y,0.0,0.4) #rise up from below
			hudUnarmed.position.y = lerp(hudUnarmed.position.y,-220.0,0.4)
			
			energyBar.value = G.player.cisEnergy
			resonanceBar.value = G.player.cisResonance
			
			if len(ammoIcons) != G.player.maxAmmoCount:
				ammoIcons.clear()
				G.freeChildren(magazine)
				for i in G.player.maxAmmoCount:
					var ammoIcon:Sprite2D = preload("Armed/AmmoIcon/AmmoIcon.tscn").instantiate()
					ammoIcon.type = G.player.ammoType
					ammoIcons.append(ammoIcon)
					magazine.add_child(ammoIcon)
					ammoIcon.position.x -= 12 * i
			for i in len(ammoIcons):
				ammoIcons[i].filled = i+1 <= G.player.ammoCount
					
		else: #unarmed HUD
			hudUnarmed.position.y = lerp(hudUnarmed.position.y,0.0,0.4) #drop down from above
			hudArmedTop.position.y = lerp(hudArmedTop.position.y,-220.0,0.4)
			hudArmedBottom.position.y = lerp(hudArmedBottom.position.y,300.0,0.4)
			
			clockPlate.rotation = 2*PI*Story.time
			creditLabel.set_text("[right]"+str(G.player.credit))
			karmaLabel.set_text("[right]"+str(G.player.karma))
	else:
		hudArmedTop.position.y = lerp(hudArmedTop.position.y,-220.0,0.4)
		hudArmedBottom.position.y = lerp(hudArmedBottom.position.y,300.0,0.4)
		hudUnarmed.position.y = lerp(hudUnarmed.position.y,-220.0,0.4)
