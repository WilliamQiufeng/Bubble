extends Window # Use Control if your root is a Control node

# Called when the scene is loaded
func _ready():
	self.borderless = true
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
