class_name Upgrade
extends Node
var texture_path: String
@onready var window = $"../../.."

func destroy_window():
	window.close()

func click():
	upgrade()
	destroy_window()

func upgrade():
	pass
