extends Node2D

@onready var skyBackground = $SkyBackground
@onready var dawnDusk = $DawnDusk
@onready var sun = $Sun
@onready var stars = $Stars
@onready var clouds = $Clouds
@onready var hiddenClouds = $HiddenClouds

const dayNightGradient:Gradient = preload("DayNightGradient.tres")
const cloudsGradient:Gradient = preload("CloudsGradient.tres")

var weather:Array = []

var tint:Color = Color(0,0,0)
var targetTint = Color(0,0,0,0)
var tintWeight:float = 0
var sunAlpha:float = 1
var weatherSpeed:float = 0.001

var dngOffset:float = 0
var dayOffset:float = 0
var starSpeed:float = 0.01
var starAlpha:float = 1

func resetAutoLoad():
	weather.clear()

	tint = Color(0,0,0)
	tintWeight = 0
	sunAlpha = 1
	weatherSpeed = 0.001

	dngOffset = 0
	dayOffset = 0
	starSpeed = 0.02
	starAlpha = 1

func notif_enteredScene(msg):
	updateSkyBackground()
func notif_loadedWorld(msg):
	stars.rotation_degrees = randf_range(0,360)
func notif_dateAdvanced(msg):
	dayOffset = 0

func _ready():
	G.followNotification(notif_enteredScene,"enteredScene")
	G.followNotification(notif_loadedWorld,"loadedWorld")
	G.followNotification(notif_dateAdvanced,"dateAdvanced")
	updateSkyBackground()
	

func _physics_process(delta):
#	if G.nearEqual(tintWeight): tint = Color(0,0,0)
	var targetTint = Color(1,1,1)
	var targetTintWeight = 0
	var targetSunAlpha = 1
	var targetStarAlpha = 1
	if "storm" in weather:
		targetTint = Color(0.3,0.3,0.3)
		targetTintWeight = 0.6
		targetSunAlpha = 0.3
		targetStarAlpha = randf()*0.2
	if "lightning" in weather:
		if T.canAdvance(self,T.TZ.WORLD):
			if randi()%200 == 0:
				var l = preload("WeatherElements/Lightning/Lightning.tscn").instantiate()
				add_child(l)
				l.position = Vector2(randi()%1400,320)
				await G.createTimer(0.5+randf()).timeout
				Audio.playEffect(preload("res://Misc/Effects/Thunder.wav"),-randf()*8,0.75+randf()/4)
	tint = G.moveColorToward(tint,targetTint,0.01)
#	tint = tint.linear_interpolate(targetTint,pow(0.1,weatherSpeed))
	tintWeight = move_toward(tintWeight,targetTintWeight,weatherSpeed*0.1)
	sunAlpha = move_toward(sunAlpha,targetSunAlpha,weatherSpeed*2)
	starAlpha = move_toward(starAlpha,targetStarAlpha,0.01)
	
	if !T.canAdvance(self): return
	
	if Story.time < dayOffset: dayOffset -= 1 #corrects lerping on new day
	dayOffset = lerp(dayOffset,Story.time,0.05) #0 midnight -> 1 midnight, goes through the entire day
	if dayOffset < 0: dayOffset += 1 #corrects lerping on new day
	
	dngOffset = lerp(dngOffset,1- abs(Story.time-0.5)/0.5,0.05) #0 darkest -> 1 brightest, bounces
	skyBackground.color = dayNightGradient.sample(dngOffset).lerp(tint,tintWeight)
	dawnDusk.modulate.a = 0
	var s = 0.2
	var e = 0.29
	if G.inRange(dayOffset,s,e): dawnDusk.modulate.a = (1-abs(dayOffset-(s+(e-s)/2)) / ((e-s)/2))*1.3
	s = 0.72
	e = 0.8
	if G.inRange(dayOffset,s,e): dawnDusk.modulate.a = (1-abs(dayOffset-(s+(e-s)/2)) / ((e-s)/2))*1.3
	dawnDusk.modulate.a = G.restrict(dawnDusk.modulate.a,0,1)
#	if G.inRange(dayOffset,0.17,0.22) || G.inRange(dayOffset,0.75,0.78): dawnDusk.modulate.a = move_toward(dawnDusk.modulate.a,1,0.0002)
#	else: dawnDusk.modulate.a = move_toward(dawnDusk.modulate.a,0,0.0002)
	
	var targetSunPositionY = getTargetSunPositionY()
	sun.position.y = targetSunPositionY#move_toward(sun.position.y,targetSunPositionY,0.2)
	sun.position.y = G.restrict(sun.position.y,400,1200)
	if G.inRange(dayOffset,0.15,0.75): sun.modulate.a = move_toward(sun.modulate.a,1,0.001)
	else: sun.modulate.a = move_toward(sun.modulate.a,0,0.01)
	sun.self_modulate.a = sunAlpha
	
	stars.rotation_degrees+=starSpeed
	stars.modulate.a = move_toward(stars.modulate.a,int(dayOffset<0.2||dayOffset>0.8),0.005)
	stars.self_modulate.a = starAlpha
	
	clouds.modulate = cloudsGradient.sample(dayOffset).lerp(tint,tintWeight)
	clouds.position.x = move_toward(clouds.position.x,(-7000+1400)*(3/4.0),0.5)
	if clouds.position.x<=(-7000+1400)*(3/4.0): clouds.position.x = (7000)*(3/4.0)
	hiddenClouds.modulate = clouds.modulate.lerp(tint,tintWeight)
	hiddenClouds.position.x = move_toward(hiddenClouds.position.x,(-7000+1400)*(3/4.0),0.05)
	if hiddenClouds.position.x<=(-7000+1400)*(3/4.0): hiddenClouds.position.x = (7000)*(3/4.0)
	
func updateSkyBackground():
	dayOffset = Story.time
	dngOffset = 1-(abs(Story.time-0.5)/0.5)
	sun.position.y = getTargetSunPositionY()
	skyBackground.color = dayNightGradient.sample(dngOffset)
	stars.modulate.a = int(dngOffset<0.4)
	clouds.modulate = cloudsGradient.sample(dayOffset)
	clouds.position.x = randf_range(-7000+1400,7000)
	hiddenClouds.position.x = randf_range(-7000+1400,7000)
func getTargetSunPositionY(): return (pow((dayOffset*2.05-1)/0.8,2)-1.1)*800+1200
