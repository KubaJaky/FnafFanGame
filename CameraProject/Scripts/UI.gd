extends CanvasLayer

@onready var PlayerCamera = $"../Player/Camera3D"
@onready var CameraRotation = PlayerCamera.rotation_degrees.y
@onready var flashlight = PlayerCamera.get_node("Flashlight")

@onready var clock = $"../Clock"
@onready var insanity_overlay = $InsanityOverlay

@onready var Cameras = $"../Monitor1"
@onready var InterfaceMonitor = $"../Monitor2"

@onready var right_door_anim = $"../SecurityDoorRight/DoorAnim"
@onready var left_door_anim = $"../SecurityDoorLeft/DoorAnim"
@onready var static_anim = $StaticNoise
@onready var eyes_anim = $Eyes
@onready var pulsing = $Pulsing
@onready var beat_sound = $HeartBeat

var insane := false

var game_over := false

func _ready():
	$EyelidTop.size = DisplayServer.window_get_size()
	$EyelidBot.size = DisplayServer.window_get_size()
	$EyelidFill.size = DisplayServer.window_get_size()
	print(DisplayServer.window_get_size(), " - ", $EyelidTop.size, " / ", $EyelidBot.size, " / ", $EyelidFill.size)

func _input(event):
	if game_over:
		if event is InputEventKey or event is InputEventMouseButton and event.pressed:
			get_tree().quit()

func _physics_process(delta):
	PlayerCamera.rotation_degrees.y = lerp(PlayerCamera.rotation_degrees.y, CameraRotation, 0.2)
	
	if !OfficeState.in_jumpscare and !OfficeState.dead:
		if Input.is_action_pressed("Flashlight") and !OfficeState.in_cameras and !OfficeState.in_fusebox:
			OfficeState.flashlight_on = true
		else:
			OfficeState.flashlight_on = false
		
		if OfficeState.flashlight_on == true:
			flashlight.light_color = "ffffff"
		else:
			flashlight.light_color = "000000"
			
			
		if Input.is_action_pressed("CalmDown") and !OfficeState.in_cameras and !OfficeState.in_fusebox and !OfficeState.eyes_closed:
			eyes_anim.play("CloseEyes")
		elif !Input.is_action_pressed("CalmDown") and OfficeState.eyes_closed:
			eyes_anim.play_backwards("CloseEyes")
			
		insanity_overlay.self_modulate = Color(1,1,1,OfficeState.insanity/100)
		beat_sound.volume_db = OfficeState.insanity/10
		
		if OfficeState.insanity >= 25 and !insane:
			insane = true
			pulsing.play("Beat1")
		elif OfficeState.insanity <= 0:
			insane = false
			
		if Input.is_action_just_pressed("Left"):
			if !OfficeState.in_cameras and !OfficeState.in_fusebox:
				if int(PlayerCamera.rotation_degrees.y) == 0:
					CameraRotation = 90.1
					OfficeState.looking_left = true
				elif int(PlayerCamera.rotation_degrees.y) == -90:
					CameraRotation = 0.0
					OfficeState.looking_right = false
		elif Input.is_action_just_pressed("Right"):
			if !OfficeState.in_cameras and !OfficeState.in_fusebox:
				if int(PlayerCamera.rotation_degrees.y) == 0:
					CameraRotation = -90.1
					OfficeState.looking_right = true
				elif int(PlayerCamera.rotation_degrees.y) == 90:
					CameraRotation = 0.0
					OfficeState.looking_left = false
	
func _on_panel_mouse_entered():
	if !OfficeState.in_jumpscare and !OfficeState.dead:
		if !OfficeState.in_cameras and !OfficeState.in_fusebox:
			if int(PlayerCamera.rotation_degrees.y) == 0:
				CameraRotation = 90.1
				OfficeState.looking_left = true
			elif int(PlayerCamera.rotation_degrees.y) == -90:
				CameraRotation = 0.0
				OfficeState.looking_right = false

func _on_panel_2_mouse_entered():
	if !OfficeState.in_jumpscare and !OfficeState.dead:
		if !OfficeState.in_cameras and !OfficeState.in_fusebox:
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
			
func check_beat():
	if insane and !OfficeState.in_jumpscare and !OfficeState.dead:
		if OfficeState.insanity >= 25 and OfficeState.insanity < 50:
			pulsing.play("Beat1")
		if OfficeState.insanity >= 50 and OfficeState.insanity < 75:
			pulsing.play("Beat2")
		elif OfficeState.insanity >= 75:
			pulsing.play("Beat3")
	else:
		pulsing.stop()
	
	
func load_static():
	OfficeState.dead = true
	static_anim.play("JumpscareTransition")

func _on_hour_timer_timeout():
	if !OfficeState.dead:
		OfficeState.hour += 1
		clock.update_hour()
		InterfaceMonitor.update_hour()

func game_over_screen():
	game_over = true
