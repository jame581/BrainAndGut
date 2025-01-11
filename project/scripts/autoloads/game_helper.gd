extends Node

var main_level: MainLevel = null

# Called when the node enters the scene tree for the first time.
func _ready():
	main_level = get_tree().root.get_node_or_null("MainLevel")
	if main_level && not (main_level as MainLevel):
		print("GameHelper: MainLevel not found in game_helper autoload.")

		# await get_tree().create_timer(3.0).timeout
		# main_level.switch_sublevel(MainLevel.SUBLEVELS.CORRIDOR)
		# await get_tree().create_timer(3.0).timeout
		# main_level.switch_sublevel(MainLevel.SUBLEVELS.GUTS)
		# await get_tree().create_timer(3.0).timeout
		# main_level.switch_sublevel(MainLevel.SUBLEVELS.BRAIN)

# Switch the current character
func switch_character():
	main_level.switch_character()

# Switch to a different sublevel
func switch_sublevel(sublevel: MainLevel.SUBLEVELS):
	main_level.switch_sublevel(sublevel)

func register_player(player):
	main_level.register_player(player)