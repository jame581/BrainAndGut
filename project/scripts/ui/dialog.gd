extends MarginContainer

class_name Dialog

signal dialog_finished()

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
		print("Dialog " + get_name() + ": Connected to InteractionArea node.")
	else:
		push_warning("Dialog " + get_name() + ": No InteractionArea node found.")		

	hide_timer.wait_time = wait_before_hide
	writing_timer.wait_time = writing_speed
	visible = false


func _on_writing_timer_timeout() -> void:
	rich_text_label.visible_characters += 1
	if rich_text_label.visible_characters == rich_text_label.get_total_character_count():
		writing_timer.stop()
		hide_timer.start()

func show_dialog(data: Dictionary) -> void:
	dialog_title = data["title"] if data.has("title") else dialog_title
	dialog_text = data["text"] if data.has("text") else dialog_text
	show_instant = data["show_instant"] if data.has("show_instant") else show_instant
	writing_speed = data["writing_speed"] if data.has("writing_speed") else writing_speed
	wait_before_hide = data["wait_time"] if data.has("wait_time") else wait_before_hide
	dialog_audio = load(data["audio"]) if data.has("audio") else dialog_audio
	dialog_audio_volume = data["audio_volume"] if data.has("audio_volume") else dialog_audio_volume

	title_label.text = dialog_title
	rich_text_label.text = dialog_text
	writing_timer.wait_time = writing_speed
	hide_timer.wait_time = wait_before_hide
	audio_player.stream = dialog_audio
	audio_player.volume_db = dialog_audio_volume
	
	handle_interaction()

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
	audio_player.stop()
	hide_timer.stop()
	print("Dialog - Dialog finished")
	dialog_finished.emit()


func _on_animation_player_animation_finished(anim_name:StringName) -> void:
	if anim_name == "hide":
		visible = false
	elif anim_name == "show":
		audio_player.play()
		if show_instant:
			hide_timer.start()
		else:
			writing_timer.start()
		
