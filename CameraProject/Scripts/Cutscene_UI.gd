extends CanvasLayer

@onready var PlayerCamera = $"../Player/Camera3D"
@onready var flashlight = PlayerCamera.get_node("Flashlight")
@onready var door_anim = $"../DoorCloseOpen"

@onready var flashlight_sound = $Flashlight
@onready var baterry_bar = $FlashlightBaterryBar

var door_closed :bool = false
var flashlight_battery :float = 100.0

@export var in_cutscene :bool = true
@export var cutscene_id :int = 1

func _physics_process(delta):
	
	if Input.is_action_just_pressed("FullScreen"):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	
	if in_cutscene or flashlight_battery <= 0:
		flashlight.light_color = "000000"
	if !in_cutscene and flashlight_battery > 0:
		if Input.is_action_pressed("Flashlight"):
			if OfficeState.flashlight_on == false:
				flashlight_sound.pitch_scale = 1.5
				flashlight_sound.play()
			OfficeState.flashlight_on = true
		else:
			if OfficeState.flashlight_on == true:
				flashlight_sound.pitch_scale = 2
				flashlight_sound.play()
			OfficeState.flashlight_on = false
		
		if OfficeState.flashlight_on == true:
			flashlight.light_color = "ffffff"
			flashlight_battery -= delta*4
		else:
			flashlight.light_color = "000000"
			
		flashlight_battery = clamp(flashlight_battery,0,100)
		baterry_bar.value = int(flashlight_battery*20)
			
	if !in_cutscene and cutscene_id == 1:
		if Input.is_action_pressed("CalmDown"):
			if door_closed == false:
				door_closed = true
				door_anim.play("Door_Close")
		else:
			if door_closed == true:
				door_closed = false
				door_anim.play_backwards("Door_Close")
