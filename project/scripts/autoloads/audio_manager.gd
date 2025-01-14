extends Node


@onready var waves_stream: AudioStreamPlayer = $WavesStream
@onready var audio_stream: AudioStreamPlayer = $AudioStream

var main_menu_music: AudioStream = preload("res://assets/sounds/music/ship-menu.mp3")
var main_level_music: AudioStream = preload("res://assets/sounds/music/shiplevel.mp3")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.map_changed.connect(handle_map_changed)
	audio_stream.stream = main_menu_music
	audio_stream.play()


func handle_map_changed(new_map_path: String) -> void:
	print("Audio Manager: Map changed to: ", new_map_path)
	if new_map_path == "res://maps/main_level.tscn":
		audio_stream.stream = main_level_music
		audio_stream.play()
		waves_stream.play()
	elif new_map_path == "res://maps/main_menu.tscn":
		audio_stream.stream = main_menu_music
		audio_stream.play()
	else:
		audio_stream.stop()
		waves_stream.play()

	