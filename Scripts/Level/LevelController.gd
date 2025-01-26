extends Node2D

@onready var popup = preload("res://UpgradePopup.tscn")

@export var current_level: int = 1

func _ready():
	on_level_advance.emit(1)

func show_upgrade_popup():
	var new_popup: UpgradePopup = popup.instantiate()
	new_popup.popup_closed.connect(next_level)
	get_tree().root.add_child(new_popup)
	new_popup.popup_centered()

func next_level():
	current_level += 1
	if current_level > len(get_children()):
		return
	var marker: Marker2D = get_node(&"Level{level}".format({"level": current_level}))
	Game.player_movement.position = marker.global_position
	on_level_advance.emit(current_level)

signal on_level_advance(level: int)
