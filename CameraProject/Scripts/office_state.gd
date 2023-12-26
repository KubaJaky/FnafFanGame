extends Node

var reset_save := false

var flashlight_on := false
var in_cameras := false
var in_fusebox := false
var eyes_closed := false

var in_jumpscare := false
var dead := false

var loading_night := 0
var night_number := 1
var hour := 5 # change to 0 later

var max_agression := false

var cpu_temp := 140.0
var power_usage := 1
var power_left := 100.0
var power_on := true
var switches_down := 0

var insanity := 0.0

var CurrentCamera := 0

var looking_left := false
var looking_right := false

var left_door_closed := false
var right_door_closed := false

var left_door_occupied := false
var right_door_occupied := false

#func _ready():
#	Engine.max_fps = 15

func _process(delta):
	if eyes_closed:
		insanity -= 0.5
		
	if power_on:
		power_left -= float(power_usage * (delta * 70))/(1000 - night_number*50)
#	print("FPS %d" % Engine.get_frames_per_second())
		
	insanity = clamp(insanity,0,100)
	power_left = clamp(power_left,0,100)
	cpu_temp = clamp(cpu_temp,140.0,220.0)
	
func reset():
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Reverb SFX"), false)
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Office SFX"), false)
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Local SFX + Reverb"), false)
	
	flashlight_on = false
	in_cameras = false
	in_fusebox = false
	eyes_closed = false

	in_jumpscare = false
	dead = false

	hour = 5 # change to 0 later

	max_agression = false

	cpu_temp = 140.0
	power_usage = 1
	power_left = 100.0
	power_on = true
	switches_down = 0

	insanity = 0.0

	CurrentCamera = 0

	looking_left = false
	looking_right = false

	left_door_closed = false
	right_door_closed = false

	left_door_occupied = false
	right_door_occupied = false
