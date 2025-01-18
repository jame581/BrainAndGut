extends Node2D

enum DoorAction { OPEN, CLOSE }

@export_category("Door Setup")
@export var locked: bool = false
@export var action: DoorAction = DoorAction.OPEN
@export_subgroup("Interaction Setup")
@export var cursor_texture: Texture = preload("res://assets/sprites/cursors/cursor_interact.png")
@export var interaction_allowed: Global.InteractionAllowed = Global.InteractionAllowed.BOTH
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

@export_subgroup("Room Setup")
@export var next_room: MainLevel.SUBLEVELS = MainLevel.SUBLEVELS.CORRIDOR
@export var force_switch_sublevel: bool = false

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var interaction_area: InteractionArea = $InteractionArea
@onready var audio_stream: AudioStreamPlayer = $AudioStreamPlayer

var is_open: bool = false

func _ready() -> void:
	interaction_area.cursor_texture = cursor_texture
	interaction_area.interaction_allowed = interaction_allowed

	animation_player.connect("animation_finished", Callable(self, "_on_animation_finished"))


func _on_interaction_area_interacted() -> void:
	print("Interaction with door")
	if dialog_on_interaction:
		dialog_on_interaction.dialog_finished.connect(_dialog_finished)
		dialog_on_interaction.show_dialog(dialog_data)

	if not locked:
		if action == DoorAction.OPEN and not is_open:
			animation_player.play("open_door")
			is_open = true
		elif action == DoorAction.CLOSE and is_open:
			animation_player.play("close_door")
			is_open = false

	if force_switch_sublevel and not dialog_on_interaction:
		GameHelper.switch_sublevel(next_room)


func unlock() -> void:
	locked = false
	interaction_area.interaction_allowed = interaction_allowed


func lock() -> void:
	locked = true
	interaction_area.interaction_allowed = Global.InteractionAllowed.NONE


func _dialog_finished() -> void:
	print("Door - Dialog finished")
	if force_switch_sublevel:
		dialog_on_interaction.dialog_finished.disconnect(_dialog_finished)
		GameHelper.switch_sublevel(next_room)


func _on_animation_finished(animation_name: String) -> void:
	if animation_name == "open_door":
		await get_tree().create_timer(1.0).timeout
		GameHelper.switch_sublevel(next_room)
		
