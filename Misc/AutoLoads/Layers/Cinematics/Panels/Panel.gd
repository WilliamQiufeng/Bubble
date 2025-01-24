extends Sprite2D


var direction:Vector2 = Vector2.ZERO
var hold:float
var shake:int = 0
var defaultOffset:Vector2
var defaultScale:int

@onready var border:Vector2 = get_viewport().size/2

func _ready():
	scale = G.v2(defaultScale)
	direction = direction.normalized()
	if direction == Vector2.ZERO: #if mode is stamp
		modulate = Color(1,1,1,0)
		scale+=G.v2(0.4)
		position = defaultOffset
	else:
		position = 2*border.x*-direction+G.remainder2(defaultOffset,border)


var phase:int = 0
func _physics_process(delta):
	randomize()
	#always shake if needed
	if shake > 0: if T.timer % shake == 0:
		offset = Vector2(randi()%shake,randi()%shake)
	
	#if move mode is stamp(direction is Vector2.ZERO)
	if direction == Vector2.ZERO:
		match phase:
			0: #entering phase
				scale = G.reach2(scale,G.v2(defaultScale),G.v2(0.04))
				modulate = Color(1,1,1,G.reach(modulate.a,1,0.1))
				if scale == G.v2(defaultScale): phase = 1
			1: #hold phase start
				phase = 2
				await G.setTimer(hold).timeout
				phase = 3
			2: #hold phase wait
				pass
			3: #exiting phase
				scale = G.reach2(scale,G.v2(4.4),G.v2(0.04))
				modulate = Color(1,1,1,G.reach0(modulate.a,0.1))
				if modulate.a == 0:
					queue_free()
				
	#else, move mode is flash
	else:
		#enter next phase if panel crosses middle point
		match phase:
			0: #enter phase
				var oldSigns = G.sign2(position-defaultOffset)
				position+=direction*30
				var signs = G.sign2(position - defaultOffset)
				if oldSigns.x!=signs.x||oldSigns.y!=signs.y:
					position = defaultOffset
					phase = 1
			1: #hold phase start
				phase = 2
				await G.setTimer(hold).timeout
				phase = 3
			2:#hold phase movement
				position+=direction/2
			3: #exit phase
				position+=direction*30
				if abs(position.x) > border.x*2 || abs(position.y)>border.y*2: queue_free()

