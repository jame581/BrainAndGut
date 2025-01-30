extends Node2D
class_name Sublevel

@export_category("Sublevel Data")
@export_subgroup("Players Setup")
@export var player_brain: Player = null
@export var player_brain_start_position: Node2D = null
@export var player_gut: Player = null
@export var player_gut_start_position: Node2D = null
@export_subgroup("Dialogs Setup")
@export var play_dialogs_on_start: bool = false
@export var data_dialogs: Array[Dictionary] = []
@export var dialog: Dialog = null

var dialogs_played: bool = false
var dialog_index: int = 0
var sub_level_active: bool = false

# Activate the sublevel
func activate() -> void:
	sub_level_active = true
	dialog_index = 0
	dialogs_played = false
	var camera = $Camera2D
	if camera as Camera2D:
		camera.make_current()
	
	print("Activated sublevel : ", get_name())

	register_players()
	
	if dialog:
		print("Dialog found")
		dialog.dialog_finished.connect(handle_dialog_finished)
		if play_dialogs_on_start and not dialogs_played:
			play_dialogs()


# Deactivate the sublevel
func deactivate() -> void:
	sub_level_active = false
	dialog_index = 0
	dialogs_played = false
	
	if dialog:
		dialog.dialog_finished.disconnect(handle_dialog_finished)
		dialog.imidiately_hide_dialog()
	
	set_players_active(false)


func play_dialogs() -> void:
	if not data_dialogs.is_empty() or dialog_index < data_dialogs.size():
		dialog.show_dialog(data_dialogs[dialog_index])
		set_players_active(false)
		print("Playing dialog: ", dialog_index)
		print("Sub level " + name + ": Players are inactive")


func handle_dialog_finished() -> void:
	dialog_index += 1
	if dialog_index < data_dialogs.size():
		play_dialogs()
	else:
		dialogs_played = true
		set_players_active(true)
		print("Players are active")


func set_players_active(active: bool) -> void:
	if player_brain:
		player_brain.set_player_active(active)
	if player_gut:
		player_gut.set_player_active(active)


func register_players() -> void:
	if player_brain:
		GameHelper.register_player(player_brain)
		if player_brain_start_position:
			player_brain.global_position = player_brain_start_position.global_position
		else:
			push_warning("Player Brain: No start position found.")

		player_brain.set_movement_target(player_brain.global_position)
		print("Registered Player Brain")
	if player_gut:
		GameHelper.register_player(player_gut)
		if player_gut_start_position:
			player_gut.global_position = player_gut_start_position.global_position
		else:
			push_warning("Player Gut: No start position found.")
		
		player_gut.set_movement_target(player_gut.global_position)
		print("Registered Player Gut")