extends CanvasLayer

@onready var PlayerCamera = $"../Player/Camera3D"
@onready var CameraRotation = PlayerCamera.rotation_degrees.y
@onready var flashlight = PlayerCamera.get_node("Flashlight")

@onready var insanity_overlay = $InsanityOverlay

@onready var Cameras = $"../Monitor1"
@onready var right_door_anim = $"../SecurityDoorRight/DoorAnim"
@onready var left_door_anim = $"../SecurityDoorLeft/DoorAnim"
@onready var eyes_anim = $Eyes

func _physics_process(delta):
	PlayerCamera.rotation_degrees.y = lerp(PlayerCamera.rotation_degrees.y, CameraRotation, 0.2)
	
	if Input.is_action_pressed("Flashlight") and !OfficeState.in_cameras:
		OfficeState.flashlight_on = true
	else:
		OfficeState.flashlight_on = false
	
	if OfficeState.flashlight_on == true:
		flashlight.light_color = "ffffff"
	else:
		flashlight.light_color = "000000"
		
		
	if Input.is_action_pressed("CalmDown") and !OfficeState.in_cameras and !OfficeState.eyes_closed:
		eyes_anim.play("CloseEyes")
	elif !Input.is_action_pressed("CalmDown") and OfficeState.eyes_closed:
		eyes_anim.play_backwards("CloseEyes")
		
	insanity_overlay.self_modulate = Color(1,1,1,OfficeState.insanity/100)
	
func _on_panel_mouse_entered():
	if !OfficeState.in_cameras:
		if int(PlayerCamera.rotation_degrees.y) == 0:
			CameraRotation = 90.1
			OfficeState.looking_left = true
		elif int(PlayerCamera.rotation_degrees.y) == -90:
			CameraRotation = 0.0
			OfficeState.looking_right = false

func _on_panel_2_mouse_entered():
	if !OfficeState.in_cameras:
		if int(PlayerCamera.rotation_degrees.y) == 0:
			CameraRotation = -90.1
			OfficeState.looking_right = true
		elif int(PlayerCamera.rotation_degrees.y) == 90:
			CameraRotation = 0.0
			OfficeState.looking_left = false
			
func toggle_eye_close():
	if OfficeState.eyes_closed == true:
		OfficeState.eyes_closed = false
	else:
		OfficeState.eyes_closed = true
			
