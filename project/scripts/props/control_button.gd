extends Node2D
class_name ControlButton

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var buttonOn: Sprite2D = $SpriteON
@onready var buttonOff: Sprite2D = $SpriteOFF

@export_subgroup("Interaction Setup")
@export var cursor_texture: Texture #= preload("res://assets/sprites/cursor.png")
@export var interaction_allowed: Global.InteractionAllowed = Global.InteractionAllowed.BOTH

@export var button_index: int = 0

var can_interact: bool = true;

# Called when the node enters the scene tree for the first time.
func _ready():
	interaction_area.cursor_texture = cursor_texture
	interaction_area.interaction_allowed = interaction_allowed

func _on_interaction_area_interacted():
	enable_button()
	print("Control Puzzle Button: interacted with control button")
	GameHelper.emit_signal("on_control_button_pressed", button_index)

func disable_button():
	buttonOff.visible = true
	interaction_area.interaction_allowed = Global.InteractionAllowed.BRAIN
	print("Control Puzzle Button: Button disabled: ", button_index)

func enable_button():
	buttonOff.visible = false
	interaction_area.interaction_allowed = Global.InteractionAllowed.NONE
	print("Control Puzzle Button: Button enabled: ", button_index)