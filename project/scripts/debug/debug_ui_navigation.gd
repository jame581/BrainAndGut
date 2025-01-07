extends CanvasLayer

@export var navigation_link: NavigationLink2D

@onready var toggle_button: Button = $ToogleDoorButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_door_button_text()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_toggle_door_button_pressed() -> void:
	navigation_link.enabled = !navigation_link.enabled
	set_door_button_text()

func set_door_button_text() -> void:
	if navigation_link.enabled:
		toggle_button.text = "Disable Door"
	else:
		toggle_button.text = "Enable Door"