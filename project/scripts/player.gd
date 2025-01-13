extends CharacterBody2D

@export_category("Player")
@export var movement_speed: float = 300.0
@export var interaction_allowed: Global.InteractionAllowed = Global.InteractionAllowed.BOTH
@export var player_index: int = 0

@onready var animation_player_brain: AnimationPlayer = $AnimationPlayerBrain
@onready var animation_player_guts: AnimationPlayer = $AnimationPlayerGuts
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var player_sprite: Sprite2D = $Sprite2D

var target_position: Vector2 = Vector2.ZERO
var is_listening: bool = false
var animation_player: AnimationPlayer = null

func _enter_tree( ) -> void:
	# Get the top-level root node
	print(get_tree().root)	
	print(get_tree().root.get_child(0))
	
	var main_level = get_tree().root.get_child(0) as MainLevel
	if main_level:
		main_level.register_player(self)

func _ready() -> void:
	if not animation_player_brain:
		push_error("Player: No AnimationPlayerBrain node found.")
	
	if not animation_player_guts:
		push_error("Player: No AnimationPlayerGuts node found.")

	animation_player = animation_player_brain if interaction_allowed == Global.Global.InteractionAllowed.BRAIN else animation_player_guts
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


func set_movement_target(movement_target: Vector2) -> void:
	navigation_agent.target_position = movement_target

func set_listening(listening: bool) -> void:
	is_listening = listening
	print("Player with name: " + get_name() + " is listening: " + str(is_listening))

func _input(event: InputEvent) -> void:
	if is_listening:
		if event.is_action_pressed("click"):
			target_position = get_global_mouse_position()
			set_movement_target(target_position)


func _physics_process(_delta: float) -> void:
	if navigation_agent.is_navigation_finished():
		velocity = Vector2.ZERO
		play_animation()
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
