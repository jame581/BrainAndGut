extends Node2D


# red = f46036
# green = 21a179
var red = Color8(244, 96, 54)
var green = Color8(33, 161, 121)

@export var sequence: Array = [0,1,2,3]
@export var buttons: Array[ControlButton] = []

var pressed: Array = []

@onready var control_panel: Sprite2D = $Art/ControlPanel

# Called when the node enters the scene tree for the first time.
func _ready():
	GameHelper.connect("on_control_button_pressed", Callable(self, "_on_control_button_pressed"))
	control_panel.modulate = Color.WHITE
	

# Handle button pressed signal
func _on_control_button_pressed(button_index: int):

	pressed.append(button_index)

	if pressed.size() > sequence.size():
		pressed.clear()
		reset_buttons()
		print("Control Puzzle: Incorrect sequence entered!")

	var pressed_index = pressed.size() - 1
	print("Control Puzzle: Button pressed: ", pressed[pressed_index])

	if pressed[pressed_index] == sequence[pressed_index]:
		#buttons[pressed_index].enable_button()

		if pressed.size() == sequence.size():
			print("Control Puzzle: Correct sequence entered!")
			control_panel.modulate = green
			GameHelper.fix_control()
			pressed.clear() 

	else:
		pressed.clear()
		reset_buttons()
		print("Control Puzzle: Incorrect sequence entered!")


func reset_buttons():
	control_panel.modulate = red
	await get_tree().create_timer(0.1).timeout
	control_panel.modulate = Color.WHITE
	await get_tree().create_timer(0.1).timeout
	control_panel.modulate = red
	await get_tree().create_timer(0.1).timeout
	control_panel.modulate = Color.WHITE
	for button in buttons:
		button.disable_button()
