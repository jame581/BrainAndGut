extends CharacterBody2D

@export_category("Player")
@export var movement_speed: float = 300.0

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var target_position: Vector2 = Vector2.ZERO

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"click"):
		target_position = get_global_mouse_position()

	# if event is InputEventMouseButton:
	# 	if event.button_index == BUTTON_LEFT and event.pressed:
	# 		target_position = get_global_mouse_position()

func _physics_process(_delta: float) -> void:

	velocity = position.direction_to(target_position) * movement_speed
	# look_at(target_position)
	if position.distance_to(target_position) > 10:
		move_and_slide()
	
	# Add the gravity.
	# if not is_on_floor():
	# 	velocity += get_gravity() * delta

	# # Handle jump.
	# if Input.is_action_just_pressed("ui_accept") and is_on_floor():
	# 	velocity.y = JUMP_VELOCITY

	# # Get the input direction and handle the movement/deceleration.
	# # As good practice, you should replace UI actions with custom gameplay actions.
	# var direction := Input.get_axis("ui_left", "ui_right")
	# if direction:
	# 	velocity.x = direction * SPEED
	# else:
	# 	velocity.x = move_toward(velocity.x, 0, SPEED)

	# move_and_slide()
