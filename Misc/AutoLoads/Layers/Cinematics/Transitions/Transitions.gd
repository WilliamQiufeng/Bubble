extends Node2D

@onready var transitionPlayer = $TransitionPlayer

func _ready():
	process_mode = PROCESS_MODE_ALWAYS
	T.addToNoTimeZone(self)
	show()

func play(animation,speed):
	assert(animation != "","Animation cannot be empty")
	assert(transitionPlayer.has_animation(animation),'No animation of name "'+animation+'"')
	transitionPlayer.seek(0)
	transitionPlayer.advance(0) #forces update, for seek(0) to take effect
	transitionPlayer.play(animation,-1,speed,speed<0)
	transitionPlayer.advance(0) #forces update, fixes animation flicker bug
	return transitionPlayer
