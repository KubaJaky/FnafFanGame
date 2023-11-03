extends Node3D

@onready var animations = $CameraMovement


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("FullScreen"):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func next1():
	animations.play("ArcadeMove")
	
func next2():
	animations.play("DiningAreaMove")
	
func next3():
	animations.play("BathroomsMove")
	
func next4():
	animations.play("ZoomOutHall")
