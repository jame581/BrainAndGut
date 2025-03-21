extends Node2D
class_name MainLevel

var players: Array = []
var current_player_index: int = 0
var active_level: Sublevel = null

# debug
var current_sublevel_index: int = 0

# Define an enum
enum SUBLEVELS { BRAIN, GUTS, CORRIDOR, ENGINE, CONTROL, CORRIDOR_GUT, BRAIN_BEGINING, EXIT }
enum CHARACTERS { BRAIN, GUTS }

@export var sublevels: Array[Sublevel] = []
@export var first_sublevel_type: SUBLEVELS = SUBLEVELS.BRAIN_BEGINING

@onready var switch_button_texture: TextureRect = $CanvasLayer/TextureRect

# Called when the node enters the scene tree for the first time.
func _ready():
	if sublevels.size() > 0:
		var first_sublevel = sublevels[first_sublevel_type]
		activate_sublevel(first_sublevel)
	
	switch_button_texture.visible = false;


# Activate a given sublevel
func activate_sublevel(sublevel: Sublevel) -> void:
	if sublevel:	
		# Deactivate the current level
		if active_level:
			active_level.deactivate()

		players.clear()
		active_level = sublevel
		reactivate_players()
		sublevel.activate()

	else:
		print("MainLevel: Sublevel is null.")	

# Function to register a new player
func register_player(player):
	players.append(player)

	if players.size() > 1:
		switch_button_texture.visible = true

# Switch to a different sublevel
func switch_sublevel(sublevel_type: SUBLEVELS):
	await Global.play_fade_in()
	print("Switching to sublevel: ", sublevel_type)
	var next_sublevel = sublevels[sublevel_type]
	activate_sublevel(next_sublevel)
	await Global.play_fade_out()

# Reactivate all players
func reactivate_players():
	current_player_index = 0
	print("MainLevel: Reactivating players")
	for player in players:
		player.set_player_active(false)

	if players.size() > 0:
		players[current_player_index].set_player_active(true)
	
	if players.size() > 1:
		switch_button_texture.visible = true

# Switches the current character to another character in the game.
func switch_character():
	if players.size() == 2:
			players[current_player_index].set_player_active(false)
			current_player_index = (current_player_index + 1) % players.size()
			players[current_player_index].set_player_active(true)
	else:
		if players.has(0):
			players[0].set_player_active(true)

# Function to handle input events
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("switch"):
		GameHelper.switch_character()
	if event.is_action_pressed("next_level"):
		current_sublevel_index = (current_sublevel_index + 1) % sublevels.size()
		GameHelper.switch_sublevel(current_sublevel_index)


func _on_switch_player_button_pressed() -> void:
	GameHelper.switch_character()
	print("MainLevel: switch player button pressed")
