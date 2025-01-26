class_name UpgradePopup
extends Window # Use Control if your root is a Control node

@onready var upgrade_button_container = $GridContainer

# Called when the scene is loaded
func _ready():
	var upgrades = [ManaUpgrade.new(), HealthUpgrade.new(), HealthRegenUpdate.new()]
	var texture_boxes = upgrade_button_container.get_children()
	self.borderless = true
	for i in range(3):
		var texture_box: TextureButton = texture_boxes[i]
		texture_box.get_child(0).texture = load(upgrades[i].texture_path)  # Load the texture using the sprite_path property
		texture_box.connect("pressed", upgrades[i].click)
		# Add the texture box as a child of the current node
		texture_box.add_child(upgrades[i])

# Function to handle button presses
func _on_button_pressed():
	print("pressssssssd")

func close():
	popup_closed.emit()
	queue_free()

signal popup_closed()

func _gui_input(event: InputEvent):
	if event is InputEventMouseMotion:
		event.ignore()  # Prevent dragging
