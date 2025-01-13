extends Area2D

class_name InteractionArea

signal interacted()

@export_category("Interaction Setup")
@export var cursor_texture: Texture = preload("res://assets/cursors/cursor_interact.png")
@export var interaction_allowed: Global.InteractionAllowed = Global.InteractionAllowed.BOTH
@export var sound_effect: AudioStream #= preload("res://assets/sounds/interact.wav")

@onready var audio_stream: AudioStreamPlayer = $AudioStreamPlayer

var can_interact: bool = false
var selected: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if sound_effect:
		audio_stream.stream = sound_effect


func _on_mouse_exited() -> void:
	#Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	Global.set_default_cursor()


func _on_mouse_entered() -> void:
	if cursor_texture:
		Input.set_custom_mouse_cursor(cursor_texture)
	else:
		Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)


func _on_body_exited(_body:Node2D) -> void:
	can_interact = false
	# selected = false


func _on_body_entered(body:Node2D) -> void:
	print("Body entered", body)
	if body is CharacterBody2D:
		print("Character entered")
		print("Interaction allowed: ", interaction_allowed)
		print("Body interaction allowed: ", body.interaction_allowed)
		if body.interaction_allowed == interaction_allowed or interaction_allowed == Global.InteractionAllowed.BOTH:
			print("Character can interact")
			can_interact = true
			on_interacted()

func on_interacted() -> void:
	print("Interacted with: ", get_name())
	print("Can interact: ", can_interact)
	print("Selected: ", selected)
	if can_interact and selected:
		audio_stream.play()
		emit_signal("interacted")
		print("Interacted with", get_name())

func _on_input_event(_viewport:Node, event:InputEvent, _shape_idx:int) -> void:
	if event is InputEventMouseButton:
		if Input.is_action_just_pressed("click"):
			print("Interaction Area - Clicked on: ", get_name())
			selected = true
