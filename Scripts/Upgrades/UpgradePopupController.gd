extends Window # Use Control if your root is a Control node

# Called when the scene is loaded
func _ready():
	var upgrades = [ManaUpgrade.new(), HealthUpgrade.new(), ManaUpgrade.new()]
	var positions = [Vector2(160, 1), Vector2(336, 0), Vector2(0, 0)]
	self.borderless = true
	for i in range(3):
		var texture_box = TextureButton.new()  # Create a new TextureRect for each upgrade
		texture_box.texture_normal = load(upgrades[i].texture_path)  # Load the texture using the sprite_path property
		texture_box.size = Vector2(64, 128)  # Set the size of the box (you can adjust this as needed)
		texture_box.position = positions[i]
		texture_box.connect("pressed", upgrades[i].upgrade)
		# Add the texture box as a child of the current node
		self.add_child(texture_box)
	
	#self.resizable = false
	# Connect signals for all buttons
	$ManaBanner.connect("pressed", Callable(self, "_on_button_pressed"))
	#$Button2.connect("pressed", Callable(self, "_on_button_pressed"))
	#$Button3.connect("pressed", Callable(self, "_on_button_pressed"))

# Function to handle button presses
func _on_button_pressed():
	print("pressssssssd")


func _gui_input(event: InputEvent):
	if event is InputEventMouseMotion:
		event.ignore()  # Prevent dragging
