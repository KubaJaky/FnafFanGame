extends Node

var flashlight_on := false
var in_cameras := false
var in_fusebox := false
var eyes_closed := false

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

func _process(delta):
	if OfficeState.eyes_closed:
		OfficeState.insanity -= 0.5
		
	insanity = clamp(insanity,0,100)
