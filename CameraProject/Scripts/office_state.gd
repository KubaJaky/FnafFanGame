extends Node

var flashlight_on := false
var in_cameras := false
var in_fusebox := false
var eyes_closed := false

var in_jumpscare := false
var dead := false

var night_number := 1
var hour := 0

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
