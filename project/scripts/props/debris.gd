extends Node2D

@export_category("Debris Setup")
@export_subgroup("Interaction Setup")
@export var cursor_texture: Texture = preload("res://assets/sprites/cursors/cursor_interact.png")
@export var interaction_allowed: Global.InteractionAllowed = Global.InteractionAllowed.BOTH
@export var open_door: Node2D = null
@export_subgroup("Dialog Setup")
@export var dialog_on_interaction: Dialog = null
@export var dialog_data: Dictionary = {
	"audio": "",
	"audio_volume": 1.0,
	"show_instant": false,
	"text": "aaa",
	"title": "Lisa",
	"wait_time": 2.0,
	"writing_speed": 0.05
}

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var interaction_area: InteractionArea = $InteractionArea

func _ready() -> void:
	interaction_area.cursor_texture = cursor_texture
	interaction_area.interaction_allowed = interaction_allowed

func _on_interaction_area_interacted() -> void:
	print("FIRE DEBUG: Interaction with debris")
	if dialog_on_interaction:
		dialog_on_interaction.dialog_finished.connect(_dialog_finished)
		dialog_on_interaction.show_dialog(dialog_data)
	else:
		animation_player.play("destroy")
		if open_door:
			open_door.unlock()


func _on_animation_player_animation_finished(anim_name:StringName) -> void:
	if anim_name == "destroy":
		queue_free()

func _dialog_finished() -> void:
	if open_door:
		open_door.unlock()
	
	animation_player.play("destroy")