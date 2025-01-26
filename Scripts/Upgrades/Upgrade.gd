extends Node
class_name Upgrade
var texture_path: String
@onready var window: UpgradePopup = $"../../.."

func destroy_window():
	window.close()

func click():
	upgrade()
	destroy_window()

func upgrade():
	pass
