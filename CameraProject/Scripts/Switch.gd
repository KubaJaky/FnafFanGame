extends StaticBody3D

@onready var switch_sound = $"../../../SwitchSound"
var switch_down := false

func _physics_process(delta):
	if switch_down and rotation_degrees.y != 140.0:
		rotation_degrees.y = lerp(float(rotation_degrees.y),140.1,0.4)
	elif !switch_down and rotation_degrees.y != 0.0:
		rotation_degrees.y = lerp(float(rotation_degrees.y),0.0,0.4)

func use():
	switch_down = false
	switch_sound.play()
	remove_from_group("Useable")
	OfficeState.switches_down -= 1
