extends Node

signal map_changed(new_map_path: String)

@onready var fade_panel: Panel = $CanvasLayer/FadePanel
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var current_scene = null
var current_path: String = ""
var cursor_default = preload("res://assets/sprites/cursors/cursor_default.png")

var player_payload = null

enum CharacterType{
	BRAIN,
	GUT
}

enum InteractionAllowed{
	BRAIN,
	GUT,
	BOTH,
	NONE
}

func _ready() -> void:
	var root = get_tree().root
	current_scene = root.get_child(-1)
	current_path = current_scene.scene_file_path
	map_changed.connect(handle_map_changed)
	set_default_cursor()
	fade_panel.hide()


func set_default_cursor() -> void:
	Input.set_custom_mouse_cursor(cursor_default)


func get_game_version() -> String:
	return "v" + ProjectSettings.get_setting("application/config/version")


func goto_scene(path):
	# This function will usually be called from a signal callback,
	# or some other function in the current scene.
	# Deleting the current scene at this point is
	# a bad idea, because it may still be executing code.
	# This will result in a crash or unexpected behavior.

	# The solution is to defer the load to a later time, when
	# we can be sure that no code from the current scene is running:

	await play_fade_in()
	_deferred_goto_scene.call_deferred(path)


func _deferred_goto_scene(path):
	# It is now safe to remove the current scene.
	current_scene.free()

	# Load the new scene.
	var s = ResourceLoader.load(path)

	# Instance the new scene.
	current_scene = s.instantiate()

	# Add it to the active scene, as child of root.
	get_tree().root.add_child(current_scene)

	# Optionally, to make it compatible with the SceneTree.change_scene_to_file() API.
	get_tree().current_scene = current_scene
	map_changed.emit(current_scene.scene_file_path)


func play_fade_in() -> void:
	animation_player.play("fade_in")
	await animation_player.animation_finished

func play_fade_out() -> void:
	animation_player.play("fade_out")
	await animation_player.animation_finished


func player_clicked_on_interacted(payload) -> void:
	player_payload = payload


func _on_animation_player_animation_finished(_anim_name:StringName) -> void:
	pass
	#if anim_name == "fade_in":
		#_deferred_goto_scene.call_deferred(load_path)

		# if load_path != "":
		# 	_deferred_goto_scene.call_deferred(load_path)
		# 	load_path = ""
		# else:
		# 	animation_player.play("fade_out")



func handle_map_changed(_new_map_path: String) -> void:
	animation_player.play("fade_out")
