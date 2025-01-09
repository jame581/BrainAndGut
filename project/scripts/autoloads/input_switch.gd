extends Node

var players: Array = []
var current_player_index: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():

	players[current_player_index].set_listening(true)

# Function to register a new player
func register_player(player):
	players.append(player)

# Function to handle input events
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("switch"):
		if players.size() == 2:
			players[current_player_index].set_listening(false)
			current_player_index = (current_player_index + 1) % players.size()
			players[current_player_index].set_listening(true)
