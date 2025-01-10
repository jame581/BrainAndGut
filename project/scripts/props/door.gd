extends Node2D


@export_category("Door Setup")
@export var locked: bool = false
@export_subgroup("Interaction Setup")
@export var cursor_texture: Texture #= preload("res://assets/sprites/cursor.png")
@export var interaction_allowed: Global.InteractionAllowed = Global.InteractionAllowed.BOTH


@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var interaction_area: InteractionArea = $InteractionArea
@onready var audio_stream: AudioStreamPlayer = $AudioStreamPlayer


func _ready() -> void:
	interaction_area.cursor_texture = cursor_texture
	interaction_area.interaction_allowed = Global.InteractionAllowed.NONE if locked else interaction_allowed


func _on_interaction_area_interacted() -> void:
	print("Interaction with door")
	animation_player.play("open")


func unlock() -> void:
	locked = false
	interaction_area.interaction_allowed = interaction_allowed


func lock() -> void:
	locked = true
	interaction_area.interaction_allowed = Global.InteractionAllowed.NONE