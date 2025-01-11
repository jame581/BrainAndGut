extends Node

@onready var wave_audio_stream: AudioStreamPlayer = $WavesStream

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.map_changed.connect(handle_map_changed)


func handle_map_changed(new_map_path: String) -> void:
	print("Audio Manager: Map changed to: ", new_map_path)
	if new_map_path == "res://maps/main_level.tscn":
		wave_audio_stream.play()
	else:
		wave_audio_stream.stop()