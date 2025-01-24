extends RefCounted
class_name RefTimer
#func get_class(): return "Custom"

signal timeout

var persistent:bool = false

var defaultTimeF:int
var timeF:int
var oneshot:bool = true
var timeZone:int = T.TZ.WORLD

var autocallCallable:Callable
var autocallArgs:Array = []
var autocallInterval:int = 1

var timeoutCallable:Callable

var disabled:bool = false

func fixedProcess():
	if disabled: return
	if is_inf(timeF): return
	if T.canAdvance(self,timeZone) && timeF > 0:
		timeF -= 1
		if timeF % autocallInterval == 0 && is_instance_valid(autocallCallable):
			autocallCallable.callv(autocallArgs)
	if timeF <= 0:
		timeout.emit()
		if is_instance_valid(timeoutCallable): timeoutCallable
		if !oneshot: timeF = defaultTimeF

func end():
	defaultTimeF = 1
	timeF = 0

func isValid():
	return timeF > 0 || is_inf(timeF)
