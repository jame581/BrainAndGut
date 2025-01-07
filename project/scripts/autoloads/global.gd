extends Node

signal map_changed(new_map_path: String)

var current_scene = null
var current_path: String = ""


func _ready() -> void:
	var root = get_tree().root
	current_scene = root.get_child(-1)
	current_path = current_scene.scene_file_path

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
