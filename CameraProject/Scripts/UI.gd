extends CanvasLayer

@onready var PlayerCamera = $"../Player/Camera3D"
@onready var CameraRotation = PlayerCamera.rotation_degrees.y
@onready var flashlight = PlayerCamera.get_node("Flashlight")

@onready var Cameras = $"../Monitor1"
@onready var right_door_anim = $"../SecurityDoorRight/DoorAnim"
@onready var left_door_anim = $"../SecurityDoorLeft/DoorAnim"

func _physics_process(delta):
	PlayerCamera.rotation_degrees.y = lerp(PlayerCamera.rotation_degrees.y, CameraRotation, 0.2)
	
	if Input.is_action_pressed("Flashlight") and !Cameras.Power:
		OfficeState.flashlight_on = true
	else:
		OfficeState.flashlight_on = false
	
	if OfficeState.flashlight_on == true:
		flashlight.light_color = "ffffff"
	else:
		flashlight.light_color = "000000"

func _on_panel_mouse_entered():
	if !Cameras.Power:
		if int(PlayerCamera.rotation_degrees.y) == 0:
			CameraRotation = 90.1
			OfficeState.looking_left = true
		elif int(PlayerCamera.rotation_degrees.y) == -90:
			CameraRotation = 0.0
			OfficeState.looking_right = false

func _on_panel_2_mouse_entered():
	if !Cameras.Power:
		if int(PlayerCamera.rotation_degrees.y) == 0:
			CameraRotation = -90.1
			OfficeState.looking_right = true
		elif int(PlayerCamera.rotation_degrees.y) == 90:
			CameraRotation = 0.0
			OfficeState.looking_left = false
			
