extends Sprite2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	# Connect to the on_engine_fixed signal from GameHelper
	GameHelper.connect("on_engine_fixed", Callable(self, "_on_engine_fixed"))

# Called when the engine is fixed
func _on_engine_fixed():
	animation_player.play("running")
	print("Engine fixed. Running animation started.")
