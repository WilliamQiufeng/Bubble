extends RefCounted
class_name RefSfx


var target:Node2D #TBS
var container:Node2D #TBS
var lifetimeF:int = 60*10 #TBS
var timeZone:int = T.TZ.WORLD

func initialize(): #TBO
	return

func fixedProcess(): #TBO
	return

func frameProcess(): #TBO
	return

func finalize(): #TBO
	return

func isValid() -> bool: #TBO
	return lifetimeF > 0 && is_instance_valid(target)

func end() -> void:
	lifetimeF = 0
