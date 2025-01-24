extends Node

var list:Array = []
	
func _ready():
	process_mode = PROCESS_MODE_ALWAYS
	T.addToNoTimeZone(self)

func _process(delta):
	for i in range(len(list)-1,-1,-1): if !is_instance_valid(list[i]): list.remove_at(i)

func resetAutoLoad(): return

#checks if a node is on top of the list
func isFocused(obj:Object): #,ignoreGameStop:bool = false        || (T.paused() && !ignoreGameStop)
	if len(list)<=0 || !is_instance_valid(obj): return false
	return obj == list[len(list)-1]

func isInList(obj:Object):
	if !is_instance_valid(obj): return false
	return obj in list

#returns the top node
func getFocused() -> Object:
	if len(list)>0: return list[len(list)-1]
	return null

#sets the entire list
func setList(array:Array[Object]): list = array.duplicate()

#removes an obj from list
func removeFocus(obj:Object):
	if isFocused(obj): G.deprecateAllInputActions()
	list.erase(obj)

#adds a node to the top of the list, focusing the node
func addFocus(obj:Object) -> bool: #false if had no effect
	if isFocused(obj): return false
	list.erase(obj)
	list.append(obj)
	G.deprecateAllInputActions()
	return true

#lists a node to the bottom of the list, prepares the node for focus
func queueFocus(obj:Object) -> bool: #false if had no effect
	if isFocused(obj) && len(list) == 1: return false
	list.erase(obj)
	list.push_front(obj)
	G.deprecateAllInputActions()
	return true

func replaceFocus(old:Object,new:Object) -> bool: #true if found and replaced
	var i:int = list.rfind(old)
	if i>=0: list[i] = new
	return i>=0
