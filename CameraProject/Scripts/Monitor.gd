extends Area3D

@onready var Cameras = $SubViewport/Cameras
@onready var AnimPlayer = $AnimationPlayer
@onready var monitor_light = $MonitorLight
@onready var PlayerCamera = $"../Player/Camera3D"
@onready var curr_camera_label = $SubViewport/TVScreen/CurrCameraLabel

var CameraNodes: Array
var CurrentCamera := 0

var CameraNames := ["Stage","Dining Area","Backstage","Arcade","Kitchen","Bathrooms","Supply Closet","W.Hall","E.Hall","Storage"]

var Power := false
var can_use := true

func _ready():
	CameraNodes = Cameras.get_children()

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
	if can_use and !Input.is_action_pressed("CalmDown") and !OfficeState.eyes_closed:
		if Power == false:
			AnimPlayer.play("On-Off")
			Power = true
			PlayerCamera.PlayerCamAnim.play("Zoom")
			OfficeState.in_cameras = true
		else:
			AnimPlayer.play_backwards("On-Off")
			Power = false
			PlayerCamera.PlayerCamAnim.play_backwards("Zoom")
			OfficeState.in_cameras = false
			
func lose_signal():
	AnimPlayer.play("LoseSignal")
	
