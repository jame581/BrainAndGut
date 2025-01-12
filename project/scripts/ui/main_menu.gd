extends Control

@export_category("Main Menu Data")
@export var ui_click_sound: AudioStream = preload("res://assets/sounds/buttons/ESM_Perfect_App_Button_5_Organic_Simple_Classic_Game_Click.wav")

@onready var exit_button: Button = $MarginContainer/HBoxContainer/RightContainer/ButtonsContainer/ExitButton
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var credit_panel: Panel = $MarginContainer/HBoxContainer/LeftContainer/MarginContainer/CreditsPanel
@onready var version_label: Label = $MarginContainer/HBoxContainer/RightContainer/VBoxContainer2/VersionLabel
@onready var audio_player: AudioStreamPlayer = $UIAudioStreamPlayer

var animation_in_progress: bool = false
var start_game: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if OS.get_name() == "Web":
		exit_button.hide()
	else:
		exit_button.show()
	
	audio_player.stream = ui_click_sound
	credit_panel.visible = false
	version_label.text = Global.get_game_version()


func _on_start_button_pressed() -> void:
	audio_player.play()
	#await get_tree().create_timer(0.1).timeout
	start_game = true
	Global.goto_scene("res://maps/main_level.tscn")


func _on_credits_button_pressed() -> void:
	if animation_in_progress:
		return

	audio_player.play()
	if credit_panel.visible:
		animation_player.play("hide_credits")
	else:
		animation_player.play("show_credits")
	
	animation_in_progress = true


func _on_exit_button_pressed() -> void:
	audio_player.play()
	get_tree().quit()


func _on_animation_player_animation_finished(_anim_name:StringName) -> void:
	animation_in_progress = false


func _on_ui_audio_stream_player_finished() -> void:
	pass
	# if start_game:
	# 	Global.goto_scene("res://maps/main_level.tscn")
