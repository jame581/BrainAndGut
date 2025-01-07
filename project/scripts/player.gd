extends CharacterBody2D

@export_category("Player")
@export var movement_speed: float = 300.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var target_position: Vector2 = Vector2.ZERO


func _ready() -> void:
	if not animation_player:
		push_error("Player: No AnimationPlayer node found.")


func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"click"):
		target_position = get_global_mouse_position()


func _physics_process(_delta: float) -> void:

	velocity = position.direction_to(target_position) * movement_speed
	# look_at(target_position)
	if position.distance_to(target_position) > 10:
		move_and_slide()
	else:
		velocity = Vector2.ZERO
	
	play_animation()


func play_animation() -> void:
	if velocity.x != 0:
		if velocity.x > 0:
			animation_player.play("walk_right")
		else:
			animation_player.play("walk_left")
	else:
		animation_player.play("idle")