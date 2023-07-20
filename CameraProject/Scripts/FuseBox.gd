extends StaticBody3D

@onready var power_down_sound = $PowerDownSound
@onready var power_on_sound = $PowerOnSound

@onready var fuse_box = $FuseBox
@onready var power_down_anim = $PowerDown
@onready var switches = get_tree().get_nodes_in_group("Switch")
@onready var open_close = $OpenClose

var switches_down := false

func use():
	if !OfficeState.in_fusebox and OfficeState.looking_right and !OfficeState.eyes_closed:
		open_close.play("OpenClose")
		OfficeState.in_fusebox = true
	else:
		open_close.play_backwards("OpenClose")
		OfficeState.in_fusebox = false
		
func _physics_process(delta):
	if Input.is_action_just_pressed("CalmDown"): # DEBUG < - Delete Later
		OfficeState.power_on = false
		
	if !OfficeState.power_on and !switches_down:
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
			
	if !OfficeState.power_on and OfficeState.switches_down == 0:
		switches_down = false
		OfficeState.power_on = true
		power_on_sound.play()
		power_down_anim.play_backwards("PowerDown")
		print("Power ON")
