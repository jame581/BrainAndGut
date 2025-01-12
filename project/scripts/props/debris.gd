extends Node2D

@export_category("Debris Setup")
@export_subgroup("Interaction Setup")
@export var cursor_texture: Texture #= preload("res://assets/sprites/cursor.png")
@export var interaction_allowed: Global.InteractionAllowed = Global.InteractionAllowed.BOTH

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var interaction_area: InteractionArea = $InteractionArea

func _ready() -> void:
	interaction_area.cursor_texture = cursor_texture
	interaction_area.interaction_allowed = interaction_allowed

func _on_interaction_area_interacted() -> void:
	animation_player.play("destroy")


func _on_animation_player_animation_finished(anim_name:StringName) -> void:
	if anim_name == "destroy":
		queue_free()
