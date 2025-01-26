extends Node
class_name Upgrade
var texture_path: String
@onready var window: UpgradePopup = $"../../.."
@onready var bubble_selection_grid: GridContainer = window.get_node("EquipedBubbles")
@onready var bubble_selection_grid_label: RichTextLabel = window.get_node("ChangeBubbleLabel")
func destroy_window():
	window.close()

func click():
	Audio.playEffect(preload("res://Misc/Effects/Confirm.wav"))
	upgrade()

func display_bubble_selection():
	bubble_selection_grid.visible = true
	bubble_selection_grid_label.visible = true
	window.size.y = 370
	window.popup_centered()

func hide_bubble_selection():
	bubble_selection_grid.visible = false
	bubble_selection_grid_label.visible = false
	window.size.y = 200
	window.popup_centered()

func upgrade():
	pass
