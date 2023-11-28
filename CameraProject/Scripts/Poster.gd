extends StaticBody3D

func use():
	var sound_id = randi_range(1,3)
	get_node("Boop" + str(sound_id)).play()
