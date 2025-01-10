extends MarginContainer

@export_category("Dialog Data")
@export var interaction_area: InteractionArea
@export_subgroup("Text")
@export var dialog_text: String = "Some cool text"
@export var dialog_title: String = "Dialog Title"
@export var writing_speed: float = 0.1
@export var wait_before_hide: float = 2.0
@export var show_instant: bool = false
@export_subgroup("Audio")
@export var dialog_audio: AudioStream
@export var dialog_audio_volume: float = 1.0

@onready var rich_text_label: RichTextLabel = $VBoxContainer/TextPanel/MarginContainer/RichTextLabel
@onready var title_label: Label = $VBoxContainer/DialogTitle
@onready var writing_timer: Timer = $WritingTimer
@onready var hide_timer: Timer = $HideTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rich_text_label.text = dialog_text
	title_label.text = dialog_title

	if interaction_area:
		interaction_area.interacted.connect(handle_interaction)
	else:
		push_error("Dialog " + get_name() + ": No InteractionArea node found.")		

	hide_timer.wait_time = wait_before_hide
	writing_timer.wait_time = writing_speed
	visible = false


func _on_writing_timer_timeout() -> void:
	rich_text_label.visible_characters += 1
	if rich_text_label.visible_characters == rich_text_label.get_total_character_count():
		writing_timer.stop()
		audio_player.stop()
		hide_timer.start()


func handle_interaction() -> void:
	print("Interaction with dialog")
	animation_player.play("show")
	if show_instant:
		rich_text_label.visible_characters = rich_text_label.get_total_character_count()
	else:
		rich_text_label.set_visible_characters(0)

	rich_text_label.set_text(dialog_text)
	visible = true


func _on_hide_timer_timeout() -> void:
	animation_player.play("hide")
	hide_timer.stop()


func _on_animation_player_animation_finished(anim_name:StringName) -> void:
	if anim_name == "hide":
		visible = false
	elif anim_name == "show":
		if show_instant:
			hide_timer.start()
		else:
			writing_timer.start()
		
