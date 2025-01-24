extends Sprite2D

@onready var cover:Sprite2D = $Cover

var filled:bool = true
var type:int = Combatant.AMMO_TYPE.RIFLE

#array index corresponds to Combatant.AMMO_TYPE
const AMMO_TEXTURES:Array[Texture] = [
	preload("RifleAmmo.png"),preload("RifleAmmo.png"),preload("RifleAmmo.png")
]
const EMPTY_TEXTURES:Array[Texture] = [
	preload("RifleAmmoEmpty.png"),preload("RifleAmmoEmpty.png"),preload("RifleAmmoEmpty.png")
]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(_delta):
	cover.visible = filled
	texture = EMPTY_TEXTURES[type]
	cover.texture = AMMO_TEXTURES[type]
