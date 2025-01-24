extends Node2D

const HINT_SCENE:PackedScene = preload("Hint.tscn")
const iconTextures:Dictionary = {
	"up":preload("Icons/Up.png")
}


func _physics_process(delta):
	for h in get_children():
		if !is_instance_valid(h.obj):
			h.queue_free()
			continue
		var index = h.get_index()
		if index == 0: h.modulate.a = 1
		else: h.modulate.a = 0.5
		h.lerpPosition.y = 400+56*index
	if G.justPressed("left") || G.justPressed("right"): goThroughHints()

func addHint(obj:Object,text:String,icon:String="up") -> void:
	var hint = getHint(obj)
	if is_instance_valid(hint):
		hint.lerpPosition.x = 132
		return
	var h = HINT_SCENE.instantiate()
	h.obj = obj
	h.text = text
	if icon.begins_with("ch_"):
		h.iconTexture = load(G.getCharacterFolderPath(icon.substr(3))+"Sprites/Faces/Default.png")
		h.iconScale = G.v2(0.4)
	else: h.iconTexture = iconTextures[icon]
	add_child(h)
	h.position = Vector2(-132,400+56*h.get_index())
func removeHint(obj:Object) -> void:
	if !hasHint(obj): return
	for h in get_children():
		if h.obj == obj:
			h.lerpPosition.x = -135
func goThroughHints() -> void: if get_child_count()>0: move_child(get_child(0),get_child_count()-1)
func hasHint(obj:Object) -> bool:
	for h in get_children(): if h.obj == obj: return true
	return false
func getHint(obj:Object) -> Object:
	for h in get_children(): if h.obj == obj: return h
	return null
func isHinting(obj:Object) -> bool: return get_child_count()>0 && get_child(0).obj == obj
	
