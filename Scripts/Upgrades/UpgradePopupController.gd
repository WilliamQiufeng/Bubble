extends Window # Use Control if your root is a Control node

@onready var upgrade_button_container = $GridContainer

# Called when the scene is loaded
func _ready():
	var upgrades = [ManaUpgrade.new(), HealthUpgrade.new(), ManaUpgrade.new()]
	var texture_boxes = upgrade_button_container.get_children()
	self.borderless = true
	for i in range(3):
		var texture_box: TextureButton = texture_boxes[i]
		texture_box.get_child(0).texture = load(upgrades[i].texture_path)  # Load the texture using the sprite_path property
		texture_box.connect("pressed", upgrades[i].upgrade)
		# Add the texture box as a child of the current node
		texture_box.add_child(upgrades[i])
	
	#self.resizable = false
	# Connect signals for all buttons
	#$Button2.connect("pressed", Callable(self, "_on_button_pressed"))
	#$Button3.connect("pressed", Callable(self, "_on_button_pressed"))

# Function to handle button presses
func _on_button_pressed():
	print("pressssssssd")


func _gui_input(event: InputEvent):
	if event is InputEventMouseMotion:
		event.ignore()  # Prevent dragging
