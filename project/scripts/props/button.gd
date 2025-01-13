extends Node2D

@onready var interaction_area: InteractionArea = $InteractionArea

@export_subgroup("Interaction Setup")
@export var cursor_texture: Texture #= preload("res://assets/sprites/cursor.png")
@export var interaction_allowed: Global.InteractionAllowed = Global.InteractionAllowed.BOTH

func _ready() -> void:
	interaction_area.cursor_texture = cursor_texture
	interaction_area.interaction_allowed = interaction_allowed



func _on_interaction_area_interacted() -> void:
	print("Interaction with door")
	GameHelper.break_button()
	queue_free()
