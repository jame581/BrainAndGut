extends Node2D

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var buttonOn: Sprite2D = $SpriteON
@onready var buttonOff: Sprite2D = $SpriteOFF

@export_subgroup("Interaction Setup")
@export var cursor_texture: Texture #= preload("res://assets/sprites/cursor.png")
@export var interaction_allowed: Global.InteractionAllowed = Global.InteractionAllowed.BOTH

@export var button_index: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	interaction_area.cursor_texture = cursor_texture
	interaction_area.interaction_allowed = interaction_allowed

func _on_interaction_area_interacted():
	GameHelper.emit_signal("on_control_button_pressed", button_index)
	print("control button: interacted with control button")
	enable_button()

func disable_button():
	buttonOff.visible = true
	interaction_area.can_interact = true

func enable_button():
	buttonOff.visible = false
	interaction_area.can_interact = false