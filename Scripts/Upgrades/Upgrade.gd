extends Node
class_name Upgrade
var texture_path: String

func destroy_window():
	var window = get_node("/root/UpgradePopup")
	if window:
		window.queue_free()

func upgrade():
	pass
