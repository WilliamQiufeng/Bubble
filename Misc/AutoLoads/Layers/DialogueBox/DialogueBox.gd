extends Node2D
class_name DialogueBox
#func get_class(): return "Custom"


#Attach this script to a main node of a potential dialogue box
#Pass in commands using "@"
#order of commands in text:
#@msg{some message}@resetArgs@{key:value;key2:value2}@options{n}PLAIN TEXT

const useTextAsCharVoice:bool = true

var timeZone:int = T.TZ.NONE
var displaying:bool = false

signal entireQueueDisplayed #when the last text in queue is displayed
signal dialogueEnded #when @end is displayed

var nameTagPrefix:String = "[center]"

const presets:Dictionary = {#name;face;voice
	"unknown":{"name":"? ? ?","face":preload("UnknownFace.png"),"voice":preload("Text.wav")}
}
#Arguments can be passed in via text using @{}
var defaultArgs = {
	"preset":"", #presets for name, face, voice
	"name":"",#speaker name
	"char":"",#speaker face, without suffix(.png, super.jpg, etc.)
	"face":"",
	"voice":"",
	"charInterval":"2",#character display speed in frames
	"echoTime":"0.8",#wait time after text completes in seconds
	"displayAfterEcho":"false",#automatically display the next dialogue
	"grabFocus":"true",#grabs focus, forbids player to move...
	"skippable":"true",#can be skipped
	"displayAfterSkip":"false",#after skipping, automatically display the next text
	"ignoreInput":"false",#ignore player input, displays from code
}
var args:Dictionary = defaultArgs.duplicate(true)

var rubyTexts:Dictionary = {} #{ charIndex : rubyText.tscn } small top texts for extra info

var queue:Array = []
var queueIndex:int = 0
#var msg:Dictionary = {"state":"default"}

@export var labelPath:NodePath
@export var optionSelectorPath:NodePath
@export var nameTagPath:NodePath
@export var faceSpritePath:NodePath
@export var advanceMarkerPath:NodePath
@export var voicePlayerPath:NodePath

@onready var label:RichTextLabel = get_node(labelPath)
@onready var defaultLabelPosition = label.position
@onready var optionSelector:Sprite2D = get_node(optionSelectorPath)
@onready var nameTag:RichTextLabel = get_node(nameTagPath)
@onready var faceSprite:Sprite2D = get_node(faceSpritePath)
@onready var advanceMarker:Sprite2D = get_node(advanceMarkerPath)
@onready var hasAdvanceMarker:bool = is_instance_valid(advanceMarker)
@onready var voicePlayer:AudioStreamPlayer = get_node(voicePlayerPath)

var echoing = false
var options = 0
var chosenOption = 0 #use await dialogueBox.optionChosen then check for chosenOption
signal optionChosen

func notif_exitScene(msg):
	endDisplay(false) #emitSignal = false, may be true?
#	G.disconnectWithAll(self,"dialogueEnded")
#	G.disconnectWithAll(self,"entireQueueDisplayed")

func _ready():
	add_to_group("dialogueBox")
	G.followNotification(notif_exitScene,"exitScene")
	modulate.a = 0
	await dialogueEnded

func _physics_process(delta):
	modulate.a = move_toward(modulate.a,int(displaying),0.2)
	if !displaying: return
	#if dialogue not complete yet and time interval allows
	if T.timer%int(args.charInterval)==0 && !isComplete():
		label.visible_characters+=1
		var nonSpace:bool = len(label.text) >= label.visible_characters\
		&& label.text.substr(label.visible_characters-1,1) != " "
		if nonSpace && (voicePlayer.get_playback_position()>0.05 || !voicePlayer.playing): voicePlayer.play()
		#if text is complete and needs to echo
		if isComplete() && options<=0:
			echo()
	#options
	optionSelector.hide()
	advanceMarker.hide()
	label.position.x = defaultLabelPosition.x
	if canAdvance() && args.ignoreInput == "false": advanceMarker.show()
	if options > 0: #displaying options
		optionSelector.show()
		optionSelector.position.y = label.position.y+optionSelector.texture.get_height()*2+chosenOption*(label.get_content_height()/options)
		label.position.x = defaultLabelPosition.x+optionSelector.texture.get_height()*4+8
		if Focus.isFocused(self):
			if G.justPressed("up") && chosenOption>0: chosenOption -= 1
			elif G.justPressed("down") && chosenOption+1<options: chosenOption += 1
			elif G.justPressedAndReleased("confirm"):
				options = 0
				optionChosen.emit()
				#call_deferred("emit_signal","optionChosen")
				displayQueue(true)
				return
	#ruby texts
	for index:int in rubyTexts: #rubyText is a child of label
		var rt:RichTextLabel = rubyTexts[index]
		if rt.positionSet: continue #optimization
		rt.positionSet = true
		if label.visible_characters >= index: rt.show()
		var line:int = label.get_character_line(index)
		rt.position.y = - rt.get_content_height()*rt.scale.y\
			+ label.get_line_offset(line)
		var i:int = index #index of first char of index's line
		while i > 0:
			if label.get_character_line(i-1) != line: break
			i -= 1
		rt.position.x = \
			(label.get_theme_font_size("normal_font_size")/float(ThemeDB.fallback_font_size))\
			*(
				label.get_theme_font("normal_font").get_string_size(
					G.stripBbcode(label.text).substr(i,index-i)
				).x + label.get_theme_font("normal_font").get_string_size(
					G.stripBbcode(label.text).substr(i,index-i+1)
				).x
			)/2.0\
			- rt.get_rect().size.x/2
	#inputs
	if Focus.isFocused(self) && args.ignoreInput == "false":
		if (G.justPressedAndReleased("confirm")) || (G.justPressedAndReleased("interact")):
			if queueIndex<len(queue):
				displayQueue()
		elif G.justPressedAndReleased("cancel") || G.justPressedAndReleased("down"):
			skipDisplay()
		
func displayEnd() -> DialogueBox:
	setQueue(["@end"])
	displayQueue()
	return self
func displayQueueAndEnd() -> DialogueBox:
	queue.append("@end")
	displayQueue()
	return self
func setAndDisplayQueueAndEnd(texts:Array) -> DialogueBox:
	setQueue(texts)
	return displayQueueAndEnd()
func setAndDisplayQueue(texts:Array) -> DialogueBox:
	setQueue(texts)
	return displayQueue()

func setQueue(texts:Array,restart:bool=true) -> void:
	queue = texts.duplicate(true)
	if restart: queueIndex = 0

func displayQueue(safe:bool=false) -> DialogueBox:
	if queueIndex >= len(queue):
		assert(safe,"Didn't setQueue()? queueIndex "+str(queueIndex)+" >= "+str(len(queue)))
		return self
	var msg:Dictionary = display(queue[queueIndex])
	if msg.state == "start": queueIndex += 1
	if msg.state == "end": queueIndex = 0
	if queueIndex>=len(queue): call_deferred("emit_signal","entireQueueDisplayed")
	return self

func endDisplay(emitSignal:bool=true,deferred:bool=false) -> Dictionary:
	if deferred: return call_deferred("endDisplay",emitSignal,false)
	isComplete(true)
	echoing = false
	options = 0
	queueIndex=0
	queue.clear()
	displaying = false
	Focus.removeFocus(self)
	resetArgs()
	if emitSignal: call_deferred("emit_signal","dialogueEnded")
	return {"state":"end"}

func skipDisplay(forced:bool=false) -> Dictionary:
	#complete the dialogue if not complete
	if args.skippable == "true" || G.DEBUGGING || forced:
		if !isComplete(true):
			if args.displayAfterSkip == "false":
				echo()
				return {"state":"skip"}
		else: return {"state":"skipRedundant"}
	return {"state":"skipFailed"}

func echo():
	if G.DEBUGGING && args.displayAfterEcho == "false": return
	echoing = true
	var echoTime:float = float(args.echoTime)
	if G.sureGreater(echoTime): await G.createTimer(echoTime,true,timeZone).timeout
	echoing = false
	if args.displayAfterEcho == "true": displayQueue()
#	elif is_instance_valid(advanceMarker): advanceMarker.show()

func display(newText) -> Dictionary:
	if echoing: return {"state":"echoing"}
	if options>0: return {"state":"choosing"}
	if !isComplete(): return {"state":"incomplete"}
	G.logMessage("Display \""+newText+"\"")
	#resets args to default
	if newText.substr(0,10) == "@resetArgs":
		resetArgs()
		newText = newText.erase(0,10)
	#extract & set args
	if newText.substr(0,2) == "@{":
		newText = newText.erase(0,2)
		newText = setDictFromStr(newText,args)
		assert(args.size() == defaultArgs.size(),"Tried to set invalid arg")
	#display options
	if newText.substr(0,9) == "@options{":
		newText = newText.erase(0,9)
		options = int(newText.substr(0,1))
		newText = newText.erase(0,2)
		chosenOption = 0
		optionSelector.show()
		optionSelector.position.y = label.position.y+optionSelector.texture.get_height()*2+chosenOption*(label.get_content_height()/options)
		label.position.x = defaultLabelPosition.x+optionSelector.texture.get_height()*4+8
	#ruby texts could be in tr file
	newText = tr(newText)
	#free previous ruby texts
	for key in rubyTexts: rubyTexts[key].queue_free()
	rubyTexts.clear()
	if newText.substr(0,6) == "@ruby{":
		newText = newText.erase(0,6)
		var rts:Dictionary = {} #temp ruby texts holder {str index:str txt}
		newText = setDictFromStr(newText,rts)
		for index:String in rts:
			assert(int(index) <= len(G.stripBbcode(newText)),"Ruby text index out of bound")
			var rt:RichTextLabel = preload("RubyText.tscn").instantiate()
			rt.txt = rts[index]
			rubyTexts[int(index)] = rt
			label.add_child(rt)
			rt.text = "[center]" + rt.txt
			rt.hide()
		
	#ends the dialogue if text is "@end"
	if newText=="@end": return endDisplay()
	#macros
	newText = newText.replace("[shake]","[shake rate=13 level=10]")
	#update nodes
	if args.preset != "":
		if is_instance_valid(nameTag): nameTag.set_text(nameTagPrefix+presets[args.preset].name)
		if is_instance_valid(faceSprite): faceSprite.texture = presets[args.preset].face
		voicePlayer.stream = presets[args.preset].voice
	if args.char != "":  # characters are kinda like presets
		if is_instance_valid(nameTag): nameTag.set_text(nameTagPrefix+args.char.capitalize().to_upper())
		if is_instance_valid(faceSprite):
			faceSprite.texture = load(G.getCharacterFolderPath(args.char)+"Sprites/Faces/"+("Default" if args.face=="" else G.cap(args.face))+".png")
			assert(faceSprite.texture!=null,args.char+" face assets incomplete: lacking "+("Default" if args.face=="" else G.cap(args.face))+".png")
		if is_instance_valid(voicePlayer):
			if useTextAsCharVoice: voicePlayer.stream = preload("Text.wav")
			else:
				voicePlayer.stream = load(G.getCharacterFolderPath(args.char)+"Audio/"+G.cap(args.char)+"Voice.wav")
				assert(voicePlayer.stream!=null,args.char+" voice assets incomplete")
	else: # manual setting, no any kind of preset
		if is_instance_valid(nameTag) && args.name != "": nameTag.set_text(nameTagPrefix+args.name)
		if is_instance_valid(faceSprite) && args.face != "":
			faceSprite.texture = load(args.face)
			assert(faceSprite.texture!=null,"Failed to load face: "+args.face)
	#		if is_instance_valid(faceSprite): faceSprite.texture = load(G.CHARACTERS_PATH+G.cap(args.char)+"/Sprites/Faces/"+G.cap(args.face)+".png")
		if is_instance_valid(voicePlayer) && args.voice != "":
			voicePlayer.stream = load(args.voice) 
			assert(voicePlayer.stream!=null,"Failed to load voice: "+args.voice)
	
	label.set_text(tr(newText))
	assert(!tr(newText).begins_with("@tr_"),"Invalid translation key "+newText)
	if options<=0: label.visible_characters = 0
	else: label.visible_characters = newText.length()
	if args.grabFocus == "true": Focus.addFocus(self)
	displaying = true
	return {"state":"start"}

func canAdvance() -> bool:
	if !isComplete(): return false # && args.skippable == "false"
	if echoing: return false
	return true
func canSkip() -> bool: return !isComplete() && args.skippable == "true"

func isComplete(autoComplete = false) -> bool:
	if label.visible_characters == -1: return true
	var r:bool = label.visible_characters >= totalCharacters()
	if autoComplete: label.visible_characters = totalCharacters()
	return r

func resetArgs() -> void: args = defaultArgs.duplicate()

func totalCharacters() -> int: return label.get_total_character_count()#getText().length()
func getText() -> String: return label.get_text()

func setDictFromStr(s:String,dict:Dictionary) -> String:
	if s.begins_with("{"): s = s.erase(0,1)
	while s[0]!="}":
		var length:int = s.find(":")
		var key:String = s.substr(0,length)
		s = s.erase(0,length+1) #erase value along with ':'
		length = s.find(";")
		var end:int = s.find("}") #could end on '}', i.e. without ';'
		var endArgs:bool = false
		if end < length || length < 0:
			length = end
			endArgs = true
		var value:String = s.substr(0,length)
		s = s.erase(0,length)
		if !endArgs: s = s.erase(0,1) #erase ';'
		dict[key] = value
	s = s.erase(0,1) #erase '}'
	return s
