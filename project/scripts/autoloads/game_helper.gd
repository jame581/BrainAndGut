extends Node

# Signal to be fired when the engine is fixed
signal on_engine_fixed
signal on_control_fixed

signal on_control_button_pressed(button_index: int)

var main_level: MainLevel = null

var button_counter: int = 0

var fixed_control: bool = false
var fixed_engine: bool = false

@export var load_outro_level: String = "res://maps/outro_2.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	setup_main_level()
	if main_level && not (main_level as MainLevel):
		print("GameHelper: MainLevel not found in game_helper autoload.")

	Global.map_changed.connect(handle_map_changed)

# Setup the main level
func setup_main_level() -> void:
	main_level = get_tree().root.get_node_or_null("MainLevel")

# Switch the current character
func switch_character():
	if not main_level:
		setup_main_level()
	
	main_level.switch_character()

# Switch to a different sublevel
func switch_sublevel(sublevel: MainLevel.SUBLEVELS):
	if not main_level:
		setup_main_level()

	main_level.switch_sublevel(sublevel)

# Register a player in the main level
func register_player(player):
	print("GameHelper: Registering player")
	if not main_level:
		setup_main_level()
	
	main_level.register_player(player)

# Saves reference to the main level after the map has changed
func handle_map_changed(_new_map_path: String) -> void:
	print("GameHelper: Map changed to: ", _new_map_path)
	main_level = get_tree().root.get_node_or_null("MainLevel")

# Increment button counter and check if the engine is fixed
func break_button():
	button_counter += 1
	if button_counter >= 4:
		fix_engine()
		
func fix_engine():
	fixed_engine = true
	emit_signal("on_engine_fixed")
	if fixed_engine && fixed_control:
		load_outro_level()


func fix_control():
	fixed_control = true
	emit_signal("on_control_fixed")
	if fixed_engine && fixed_control:
		load_outro_level()

func load_outro_level() -> void:
	await get_tree().create_timer(1.0).timeout
	if load_outro_level:
		Global.goto_scene(load_outro_level)