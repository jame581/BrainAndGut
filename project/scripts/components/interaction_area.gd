extends Area2D

class_name InteractionArea

signal interacted()

@export_category("Interaction Setup")
@export var cursor_texture: Texture = preload("res://assets/cursors/cursor_interact.png")
@export var interaction_allowed: Global.InteractionAllowed = Global.InteractionAllowed.BOTH
@export var sound_effect: AudioStream #= preload("res://assets/sounds/interact.wav")
@export var player_animation: String

@onready var audio_stream: AudioStreamPlayer = $AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if sound_effect:
		audio_stream.stream = sound_effect


func _on_mouse_exited() -> void:
	Global.set_default_cursor()


func _on_mouse_entered() -> void:
	if cursor_texture:
		Input.set_custom_mouse_cursor(cursor_texture)
	else:
		Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)


func interact(body:Node2D) -> void:
	print("FIRE DEBUG: InteractionArea interact()")
	if body is CharacterBody2D:
		if body.interaction_allowed == interaction_allowed or interaction_allowed == Global.InteractionAllowed.BOTH:
			print("FIRE DEBUG: Character interacted")
			emit_signal("interacted")


func _on_input_event(_viewport:Node, event:InputEvent, _shape_idx:int) -> void:
	if event is InputEventMouseButton and Input.is_action_just_pressed("click"):
		Global.player_clicked_on_interacted(self)
