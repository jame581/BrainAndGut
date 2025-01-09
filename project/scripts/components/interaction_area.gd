extends Area2D

class_name InteractionArea

@export_category("Interaction Setup")
@export var cursor_texture: Texture #= preload("res://assets/sprites/cursor.png")
@export var interaction_allowed: Global.InteractionAllowed = Global.InteractionAllowed.BOTH

signal interacted()

var can_interact: bool = false

# # Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta: float) -> void:
# 	pass

func _on_mouse_exited() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	#Input.set_custom_mouse_cursor(null)


func _on_mouse_entered() -> void:
	if cursor_texture:
		Input.set_custom_mouse_cursor(cursor_texture)
	else:
		Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)


func _on_body_exited(_body:Node2D) -> void:
	can_interact = false


func _on_body_entered(body:Node2D) -> void:
	if body is CharacterBody2D:
		if body.interaction_allowed == interaction_allowed:
			can_interact = true
			on_interacted()

func on_interacted() -> void:
	if can_interact:
		emit_signal("interacted")
		print("Interacted with", get_name())