extends TextureRect
@onready var texture_rect = $TextureRect


# Called when the node enters the scene tree for the first time.
func _ready():
	Game.player_movement.player_weapon_state.active_bullet_type_change.connect(_check)

func _check(_index: int, type: Constants.BulletType):
	match type:
		Constants.BulletType.TINY:
			texture_rect.scale = Vector2.ONE * 0.25
		Constants.BulletType.SUPPLEMENT:
			texture_rect.scale = Vector2.ONE * 0.75
			

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
  
