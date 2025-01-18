extends Node2D
class_name Sublevel

@export_category("Sublevel Data")
@export_subgroup("Dialogs Setup")
@export var play_dialogs_on_start: bool = false
@export var data_dialogs: Array[Dictionary] = []
@export var dialog: Dialog = null

var dialogs_played: bool = false
var dialog_index: int = 0

# Activate the sublevel
func activate() -> void:
	dialog_index = 0
	dialogs_played = false
	var camera = $Camera2D
	if camera as Camera2D:
		camera.make_current()
	
	print("Activated sublevel : ", get_name())

	if $Player1:
		GameHelper.register_player($Player1)
		print("Registered Player1")
	if get_node_or_null("Player2"):
		GameHelper.register_player($Player2)
		print("Registered Player2")
	
	if dialog:
		print("Dialog found")
		dialog.dialog_finished.connect(handle_dialog_finished)
		if play_dialogs_on_start and not dialogs_played:
			play_dialogs()

# Deactivate the sublevel
func deactivate() -> void:
	dialog_index = 0
	dialogs_played = false
	
	if dialog:
		dialog.dialog_finished.disconnect(handle_dialog_finished)
		dialog.imidiately_hide_dialog()
	
	if $Player1:
		$Player1.set_player_active(false)
	if get_node_or_null("Player2"):
		$Player2.set_player_active(false)


func play_dialogs() -> void:
	if not data_dialogs.is_empty() or dialog_index < data_dialogs.size():
		dialog.show_dialog(data_dialogs[dialog_index]) 


func handle_dialog_finished() -> void:
	dialog_index += 1
	if dialog_index < data_dialogs.size():
		play_dialogs()
	else:
		dialogs_played = true