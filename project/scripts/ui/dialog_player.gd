extends Node2D

@export_group("Dialog Data")
@export var enabled: bool = true
@export var dialog_display: Dialog
@export var start_wait_time: float = 2.0
@export var load_level_after: String = "res://maps/main_level.tscn"
@export var main_menu: String = "res://maps/main_menu.tscn"
@export var animation_player: AnimationPlayer
@export var animation_player2: AnimationPlayer
@export_file("*.json") var dialog_text_file
@export var wait_for_input: bool = false

@onready var timer = $Timer
@onready var load_level_timer = $LoadLevelTimer

var dialogs_data: Array = []
var dialog_index: int = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	parse_json()
	timer.wait_time = start_wait_time
	dialog_display.dialog_finished.connect(next_message)
	
	if animation_player == null:
		push_error("Animation player not set")

	if dialogs_data.size() > 0 and enabled:
		timer.start()


# func _input(event: InputEvent) -> void:
# 	if event.is_action_pressed("skip_dialog_text") and dialog_display:		
# 		dialog_display.imidiately_hide_dialog()
# 		next_message()

func parse_json() -> void:

	var file_content = load_dialog_text()
	var json = JSON.new()
	var error = json.parse(file_content)
	var dialog_data_json : Dictionary

	if error != OK:
		push_error("Error parsing JSON")
	else:
		dialog_data_json = json.get_data()
		dialogs_data = dialog_data_json["dialogs"]


func load_dialog_text() -> String:
	var file = FileAccess.open(dialog_text_file, FileAccess.READ)
	var content = file.get_as_text()
	file.close()
	return content


func next_message() -> void:
	if dialog_index < dialogs_data.size():
		dialog_display.show_dialog(dialogs_data[dialog_index])
		if dialogs_data[dialog_index].has("animation") and animation_player != null:
			animation_player.play(dialogs_data[dialog_index]["animation"])
		if dialogs_data[dialog_index].has("animation2") and animation_player2 != null:
			animation_player2.play(dialogs_data[dialog_index]["animation2"])
		dialog_index += 1
	else:
		load_level_timer.start()

func load_next_level() -> void:
	if load_level_after:
		Global.goto_scene(load_level_after)

func load_main_menu() -> void:
	if main_menu:
		Global.goto_scene(main_menu)

func _on_timer_timeout() -> void:
	next_message()


func _on_load_level_timer_timeout() -> void:
	load_next_level()