extends Node2D
class_name Sublevel

# Activate the sublevel
func activate() -> void:
	var camera = $Camera2D
	if camera as Camera2D:
		camera.make_current()
	
	print("Activated sublevel : ", get_name())

	if $Player1:
		GameHelper.register_player($Player1)
		print("Registered Player1")
	if $Player2:
		GameHelper.register_player($Player2)
		print("Registered Player2")

# Deactivate the sublevel
func deactivate() -> void:
	pass
