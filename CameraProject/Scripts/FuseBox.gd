extends StaticBody3D

@onready var power_down_sound = $PowerDownSound
@onready var power_on_sound = $PowerOnSound

@onready var fuse_box = $FuseBox
@onready var power_down_anim = $PowerDown
@onready var switches = get_tree().get_nodes_in_group("Switch")
@onready var open_close = $OpenClose

@onready var open_sound = $OpenSound
@onready var close_sound = $CloseSound

var switches_down := false

func use():
	if !OfficeState.in_fusebox and OfficeState.looking_right and !OfficeState.eyes_closed:
		OfficeState.in_fusebox = true
		open_close.play("OpenClose")
	else:
		OfficeState.in_fusebox = false
		open_close.play_backwards("OpenClose")
		
func opening():
	if OfficeState.in_fusebox:
		open_sound.play()
	
func closing():
	if !OfficeState.in_fusebox:
		close_sound.play()
		
func blackout():
	if OfficeState.power_on:
		OfficeState.power_on = false
		
func _physics_process(delta):
	#if Input.is_action_just_pressed("CalmDown"): # DEBUG < - Delete Later
		#OfficeState.power_on = false
		
	if OfficeState.power_left <= 0 and OfficeState.power_on:
		OfficeState.power_on = false
		power_down_anim.play("PowerDown")
		print("Power OFF")
		
	if !OfficeState.power_on and !switches_down and OfficeState.power_left > 0:
		switches_down = true
		power_down_sound.play()
		power_down_anim.play("PowerDown")
		print("Power OFF")
		var switch_count = randi_range(2,7)
		for switch in switch_count:
			var id = randi_range(0,7)
			while switches[id].switch_down == true:
				id = randi_range(0,7)
			switches[id].switch_down = true
			switches[id].add_to_group("Useable")
			OfficeState.switches_down += 1
			
	if !OfficeState.power_on and OfficeState.switches_down == 0 and OfficeState.power_left > 0:
		switches_down = false
		OfficeState.power_on = true
		power_on_sound.play()
		power_down_anim.play_backwards("PowerDown")
		print("Power ON")
