extends CharacterBody2D

class_name Player

# export variables
@export_category("Player")
@export var character_type: Global.CharacterType = Global.CharacterType.BRAIN
@export var movement_speed: float = 300.0
@export var interaction_allowed: Global.InteractionAllowed = Global.InteractionAllowed.BOTH
@export var player_index: int = 0
@export var interaction_distance: float = 250.0

# load on ready variables
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var player_sprite: Sprite2D = $Sprite2D

# local variables
var target_position: Vector2 = Vector2.ZERO
var player_is_active: bool = false

func _enter_tree( ) -> void:
	# Get the top-level root node
	print(get_tree().root)	
	print(get_tree().root.get_child(0))
	
	var main_level = get_tree().root.get_child(0) as MainLevel
	if main_level:
		main_level.register_player(self)


func _ready() -> void:
	if not animation_player:
		push_error("Player " + name + ": No AnimationPlayer node found.")

	target_position = global_position

	# These values need to be adjusted for the actor's speed
	# and the navigation layout.
	navigation_agent.path_desired_distance = 4.0
	navigation_agent.target_desired_distance = 4.0

	# Make sure to not await during _ready.
	actor_setup.call_deferred()


func actor_setup() -> void:
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame

	# Now that the navigation map is no longer empty, set the movement target.
	set_movement_target(target_position)


func get_character_type() -> Global.CharacterType:
	return character_type


func set_movement_target(movement_target: Vector2) -> void:
	target_position = movement_target
	navigation_agent.target_position = movement_target


func set_player_active(active: bool) -> void:
	print("Player " + name + " is active: ", active)
	player_is_active = active


func _input(event: InputEvent) -> void:
	#print("Player " + name + " input: player_is_active: ", player_is_active)
	if player_is_active and event.is_action_pressed("click"):
		Global.player_payload = null
		target_position = get_global_mouse_position()
		set_movement_target(target_position)


func _physics_process(_delta: float) -> void:
	if not player_is_active:
		velocity = Vector2.ZERO
		play_animation()
		return
	
	# Check if the navigation map is ready
	if NavigationServer2D.map_get_iteration_id(navigation_agent.get_navigation_map()) == 0:
		return

	if navigation_agent.is_navigation_finished():
		velocity = Vector2.ZERO
		play_animation()
		if Global.player_payload:
			# check if player is in interaction distance
			print("Player " + name + " is in location: ", global_position)
			print("Player payload is in global_position: ", Global.player_payload.global_position)
			print("Player payload is in position: ", Global.player_payload.position)
			print("Player " + name + " is in interaction distance: ", global_position.distance_to(Global.player_payload.global_position))
			if global_position.distance_to(Global.player_payload.global_position) < interaction_distance:
				Global.player_payload.interact(self)
				print("Player " + name + " is interacting with: ", Global.player_payload)
				Global.player_payload = null
		return
	
	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()

	velocity = current_agent_position.direction_to(next_path_position) * movement_speed
	
	play_animation()
	move_and_slide()


func play_animation() -> void:
	if velocity.x != 0:
		if velocity.x > 0:
			animation_player.play("walk")
			player_sprite.flip_h = false
		else:
			animation_player.play("walk")
			player_sprite.flip_h = true
	else:
		animation_player.play("idle")
