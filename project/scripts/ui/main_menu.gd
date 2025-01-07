extends Control


@onready var exit_button: Button = $MarginContainer/HBoxContainer/RightContainer/ButtonsContainer/ExitButton
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var credit_panel: Panel = $MarginContainer/HBoxContainer/LeftContainer/MarginContainer/CreditsPanel
@onready var version_label: Label = $MarginContainer/HBoxContainer/RightContainer/VBoxContainer2/VersionLabel

var animation_in_progress: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if OS.get_name() == "Web":
		exit_button.hide()
	else:
		exit_button.show()
	
	credit_panel.visible = false
	version_label.text = Global.get_game_version()


func _on_start_button_pressed() -> void:
	Global.goto_scene("res://maps/main.tscn")


func _on_credits_button_pressed() -> void:
	if animation_in_progress:
		return

	if credit_panel.visible:
		animation_player.play("hide_credits")
	else:
		animation_player.play("show_credits")
	
	animation_in_progress = true


func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _on_animation_player_animation_finished(_anim_name:StringName) -> void:
	animation_in_progress = false
