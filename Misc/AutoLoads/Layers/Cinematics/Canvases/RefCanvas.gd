extends RefCounted
class_name RefCanvas
#func get_class(): return "Custom"

var image
var transition:String = "fade"
var revealTransition:String="same"
var transitionSpeed:float=1
var revealTransitionSpeed:float=1
var interval:float=0.5
var displayAfterEcho:bool = true
var echoTime:float = 2
var text:String = ""


