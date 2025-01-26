class_name UpgradePopup
extends Window # Use Control if your root is a Control node

@onready var upgrade_button_container = $GridContainer
@onready var equiped_bubbles: GridContainer = $EquipedBubbles

# Called when the scene is loaded
func _ready():
	var avail_upgrades = [ManaUpgrade.new(), HealthUpgrade.new(), HealthRegenUpgrade.new()]
	var bubble_icons = {
		Constants.EffectType.THE_WORLD: "res://Scripts/Bubbles/Sprites/Icons/BubbleIconClock.png",
		Constants.EffectType.TELEPORT: "res://Scripts/Bubbles/Sprites/Icons/BubbleIconTp.png",
		Constants.EffectType.DASH: "res://Scripts/Bubbles/Sprites/Icons/BubbleIconMovement.png", 
		Constants.EffectType.SWORD: "res://Scripts/Bubbles/Sprites/Icons/BubbleIconSword.png"}
	for effect in bubble_icons:
		avail_upgrades.append(BubbleUpgrade.new(bubble_icons[effect], effect))
	
	var texture_boxes = upgrade_button_container.get_children()
	var bubble_boxes = equiped_bubbles.get_children()
	self.borderless = true
	var upgrades = pick_random_elements(avail_upgrades, 3)
	for i in range(3):
		var texture_box: TextureButton = texture_boxes[i]
		texture_box.get_child(0).texture = load(upgrades[i].texture_path)  # Load the texture using the sprite_path property
		texture_box.connect("pressed", upgrades[i].click)
		# Add the texture box as a child of the current node
		texture_box.add_child(upgrades[i])
	
	var equiped_bubbles = Game.equiped_bubbles
	for i in range(3):
		bubble_boxes[i].get_child(0).texture = load(bubble_icons[equiped_bubbles[i]])
		

func pick_random_elements(input_list: Array, count: int) -> Array:
	# Ensure count is not larger than the list size
	count = min(count, input_list.size())
	
	# Create a shuffled copy of the list
	var shuffled_list = input_list.duplicate()
	shuffled_list.shuffle()
	
	# Return the first `count` elements from the shuffled list
	return shuffled_list.slice(0, count)

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
