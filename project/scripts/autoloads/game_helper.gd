extends Node

# Signal to be fired when the engine is fixed
signal on_engine_fixed

var main_level: MainLevel = null

var button_counter: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	setup_main_level()
	if main_level && not (main_level as MainLevel):
		print("GameHelper: MainLevel not found in game_helper autoload.")

	Global.map_changed.connect(handle_map_changed)

		# await get_tree().create_timer(3.0).timeout
		# main_level.switch_sublevel(MainLevel.SUBLEVELS.CORRIDOR)
		# await get_tree().create_timer(3.0).timeout
		# main_level.switch_sublevel(MainLevel.SUBLEVELS.GUTS)
		# await get_tree().create_timer(3.0).timeout
		# main_level.switch_sublevel(MainLevel.SUBLEVELS.BRAIN)

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

func register_player(player):
	print("GameHelper: Registering player")
	if not main_level:
		setup_main_level()
	
	main_level.register_player(player)

func handle_map_changed(_new_map_path: String) -> void:
	print("GameHelper: Map changed to: ", _new_map_path)
	main_level = get_tree().root.get_node_or_null("MainLevel")

# Increment button counter and check if the engine is fixed
func break_button():
	button_counter += 1
	if button_counter >= 4:
		emit_signal("on_engine_fixed")
		print("GameHelper: Engine fixed.")
