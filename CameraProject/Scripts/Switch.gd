extends StaticBody3D

var switch_down := false

func _physics_process(delta):
	if switch_down and rotation_degrees.y != 140.0:
		rotation_degrees.y = lerp(float(rotation_degrees.y),140.1,0.4)
	elif !switch_down and rotation_degrees.y != 0.0:
		rotation_degrees.y = lerp(float(rotation_degrees.y),0.0,0.4)

func use():
	switch_down = false
	remove_from_group("Useable")
	OfficeState.switches_down -= 1
