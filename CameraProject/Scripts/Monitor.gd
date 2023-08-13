extends Area3D

@onready var Cameras = $SubViewport/Cameras
@onready var AnimPlayer = $AnimationPlayer
@onready var monitor_light = $MonitorLight
@onready var PlayerCamera = $"../Player/Camera3D"
@onready var curr_camera_label = $SubViewport/TVScreen/CurrCameraLabel

@onready var pc_fan_sound = $PCFanSound
@onready var pc_crash_sound = $PCCrashSound

var CameraNodes: Array
var CurrentCamera := 0

var changing_cam := false

var CameraNames := ["Stage","Dining Area","Backstage","Arcade","Kitchen","Bathrooms","Supply Closet","W.Hall","E.Hall","Storage"]

var Power := false
var can_use := true
var bluescreen := false

func _ready():
	CameraNodes = Cameras.get_children()
	
func _physics_process(delta):
	if Power == true and !bluescreen:
		OfficeState.cpu_temp += 0.02
		pc_fan_sound.max_db = lerp(pc_fan_sound.max_db, -14 + OfficeState.cpu_temp/20, 0.6)
	elif !bluescreen:
		OfficeState.cpu_temp -= 0.2
	if AnimPlayer.is_playing() and AnimPlayer.current_animation == "Change":
		changing_cam = true
	else:
		changing_cam = false
		
	if Power == true and !OfficeState.power_on:
		Power = false
		AnimPlayer.play_backwards("On-Off")
		PlayerCamera.PlayerCamAnim.play_backwards("Zoom")
		OfficeState.in_cameras = false
		OfficeState.power_usage -= 2
	if Power == true and OfficeState.cpu_temp >= 200 and !bluescreen:
		bluescreen = true
		can_use = false
		AnimPlayer.play("Bluescreen")
		PlayerCamera.PlayerCamAnim.play_backwards("Zoom")
		OfficeState.in_cameras = false

func change_cam(cam_num):
	if Power == true:
		AnimPlayer.play("Change")
		CurrentCamera = cam_num
		OfficeState.CurrentCamera = CurrentCamera
		if CurrentCamera == CameraNodes.size():
			CurrentCamera = 0
		var SecurityCam = CameraNodes[CurrentCamera].SecurityCamera
		SecurityCam.make_current()
		if (CurrentCamera+1) < 10:
			curr_camera_label.text = ' CAM  "' + CameraNames[CurrentCamera] + '"
	  0' + str(CurrentCamera+1)
		else:
			curr_camera_label.text = ' CAM  "' + CameraNames[CurrentCamera] + '"
	  ' + str(CurrentCamera+1)
			
func use():
	if can_use and !Input.is_action_pressed("CalmDown") and !OfficeState.eyes_closed and OfficeState.power_on:
		if Power == false:
			AnimPlayer.play("On-Off")
			Power = true
			PlayerCamera.PlayerCamAnim.play("Zoom")
			OfficeState.in_cameras = true
			OfficeState.power_usage += 2
		else:
			AnimPlayer.play_backwards("On-Off")
			Power = false
			PlayerCamera.PlayerCamAnim.play_backwards("Zoom")
			OfficeState.in_cameras = false
			OfficeState.power_usage -= 2
		
			
func lose_signal():
	AnimPlayer.play("LoseSignal")
	
func end_bluescreen():
	bluescreen = false
	OfficeState.cpu_temp = 140.0
	Power = false
	OfficeState.power_usage -= 2
	AnimPlayer.play_backwards("On-Off")
	can_use = true
