extends Node2D


# red = f46036
# green = 21a179
var red = Color8(244, 96, 54)
var green = Color8(33, 161, 121)

@export var sequence: Array = [0,1,2,3]
var pressed: Array = []


@onready var buttons: Array = $Buttons.get_children()
@onready var control_panel: Sprite2D = $Art/ControlPanel

# Called when the node enters the scene tree for the first time.
func _ready():
	GameHelper.connect("on_control_button_pressed", Callable(self, "_on_control_button_pressed"))
	control_panel.modulate = red
	

# Handle button pressed signal
func _on_control_button_pressed(button_index: int):

	pressed.append(button_index)

	if pressed.size() > sequence.size():
		pressed.clear()

	if pressed == sequence.slice(0, pressed.size()):
		if pressed.size() == sequence.size():
			print("Correct sequence entered!")
			control_panel.modulate = green
			pressed.clear()
	else:
		pressed.clear()
		reset_buttons()
		print("Incorrect sequence entered!")


func reset_buttons():
	for button in buttons:
		button.disable_button()
