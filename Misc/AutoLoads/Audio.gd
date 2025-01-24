extends Node

func resetAutoLoad(): pass

func _ready():
	process_mode = PROCESS_MODE_ALWAYS
	T.addToNoTimeZone(self)
	
func playEffect(stream:AudioStream,volumeDb:float=0,pitchScale:float=1):
	if stream is AudioStreamWAV: assert(stream.loop_mode==stream.LOOP_DISABLED,"Effects cannot be looped")
	else: assert(!stream.loop,"Effects cannot be looped")
	var effectPlayer = AudioStreamPlayer.new()
	effectPlayer.stream = stream
	effectPlayer.volume_db = volumeDb
	effectPlayer.pitch_scale = pitchScale
	add_child(effectPlayer)
	yieldFreeEffectPlayer(effectPlayer)
	effectPlayer.play()
	return effectPlayer
func yieldFreeEffectPlayer(effectPlayer:AudioStreamPlayer):
	await effectPlayer.finished
	effectPlayer.queue_free()

func setVolume(busName:String,percent:float):
	if G.nearEqual(percent): AudioServer.set_bus_volume_db(getBusIndex(busName),-60)
	else: AudioServer.set_bus_volume_db(getBusIndex(busName),G.percentToDb(percent))

func setVolumeDb(busName:String,db:float):
	db = G.restrict(db,-60,16)
	AudioServer.set_bus_volume_db(getBusIndex(busName),db)

func getBusIndex(busName:String="Master") -> int:
	return AudioServer.get_bus_index(busName)
