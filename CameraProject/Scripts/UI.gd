extends CanvasLayer

@onready var PlayerCamera = $"../Player/Camera3D"
@onready var CameraRotation = PlayerCamera.rotation_degrees.y
@onready var flashlight = PlayerCamera.get_node("Flashlight")

@onready var save = $"../Save"

@onready var clock = $"../Clock"
@onready var insanity_overlay = $InsanityOverlay
@onready var insanity_anim = $"../InsanityEyes/InsanityAnim"
@onready var insanity_eyes_node = $"../InsanityEyes"

@onready var Cameras = $"../Monitor1"
@onready var InterfaceMonitor = $"../Monitor2"

@onready var right_door_anim = $"../SecurityDoorRight/DoorAnim"
@onready var left_door_anim = $"../SecurityDoorLeft/DoorAnim"
@onready var static_anim = $StaticNoise
@onready var win_anim = $"6AM"
@onready var eyes_anim = $Eyes
@onready var pulsing = $Pulsing
@onready var beat_sound = $HeartBeat
@onready var flashlight_sound = $Flashlight
@onready var stinger_sound = $Stinger
@onready var jumpscare_sound = $Jumpscare
@onready var jumpscare_short = $JumpscareShort

var night_5_end := false

var play_chance = 4 #Ambience

var insane := false
var insanity_eyes := false

var game_over := false

func _ready():
	$EyelidTop.size = DisplayServer.window_get_size()
	$EyelidBot.size = DisplayServer.window_get_size()
	$EyelidFill.size = DisplayServer.window_get_size()
	print(DisplayServer.window_get_size(), " - ", $EyelidTop.size, " / ", $EyelidBot.size, " / ", $EyelidFill.size)
	$InsanityOverlay.visible = true
	$InsanityOverlay.modulate = "ffffff00"
	# Fix this /\ so it doesn't appear at the start of the night
	# and still appears when insanity goes up
	
	# Don't know how you'll do it. Have fun!
	

func _input(event):
	if game_over:
		if event is InputEventKey or event is InputEventMouseButton and event.pressed:
			get_tree().quit()

func _physics_process(delta):
	
	if Input.is_action_just_pressed("FullScreen"):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	
	PlayerCamera.rotation_degrees.y = lerp(PlayerCamera.rotation_degrees.y, CameraRotation, 0.2)
	
	if !OfficeState.in_jumpscare and !OfficeState.dead and !OfficeState.hour >= 6:
		flashlight.light_color = "000000"
	if !OfficeState.in_jumpscare and !OfficeState.dead:
		if Input.is_action_pressed("Flashlight") and !OfficeState.in_cameras and !OfficeState.in_fusebox:
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
			
		if OfficeState.insanity >= 50 and !insanity_eyes:
			if !OfficeState.looking_left and !OfficeState.flashlight_on or !OfficeState.looking_right and !OfficeState.flashlight_on:
				insanity_eyes = true
				insanity_anim.play_backwards("EyesFade")
		elif OfficeState.insanity < 50 and insanity_eyes:
			if !OfficeState.looking_left and !OfficeState.flashlight_on or !OfficeState.looking_right and !OfficeState.flashlight_on:
				insanity_eyes = false
				insanity_anim.play("EyesFade")
				
		if insanity_eyes:
			if OfficeState.looking_left and OfficeState.flashlight_on or OfficeState.looking_right and OfficeState.flashlight_on:
				insanity_eyes_node.visible = false
			elif !insanity_eyes_node.visible and !insanity_anim.is_playing():
				insanity_eyes_node.visible = true
						
		if Input.is_action_just_pressed("Left"):
			if !OfficeState.in_cameras and !OfficeState.in_fusebox and !OfficeState.eyes_closed:
				if int(PlayerCamera.rotation_degrees.y) == 0:
					CameraRotation = 90.1
					OfficeState.looking_left = true
				elif int(PlayerCamera.rotation_degrees.y) == -90:
					CameraRotation = 0.0
					OfficeState.looking_right = false
		elif Input.is_action_just_pressed("Right"):
			if !OfficeState.in_cameras and !OfficeState.in_fusebox and !OfficeState.eyes_closed:
				if int(PlayerCamera.rotation_degrees.y) == 0:
					CameraRotation = -90.1
					OfficeState.looking_right = true
				elif int(PlayerCamera.rotation_degrees.y) == 90:
					CameraRotation = 0.0
					OfficeState.looking_left = false
	
func _on_panel_mouse_entered():
	if !OfficeState.in_jumpscare and !OfficeState.dead and !OfficeState.eyes_closed:
		if !OfficeState.in_cameras and !OfficeState.in_fusebox:
			if int(PlayerCamera.rotation_degrees.y) == 0:
				CameraRotation = 90.1
				OfficeState.looking_left = true
			elif int(PlayerCamera.rotation_degrees.y) == -90:
				CameraRotation = 0.0
				OfficeState.looking_right = false

func _on_panel_2_mouse_entered():
	if !OfficeState.in_jumpscare and !OfficeState.dead and !OfficeState.eyes_closed:
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
	if insane and !OfficeState.in_jumpscare and !OfficeState.dead and !OfficeState.hour >= 6:
		if OfficeState.insanity >= 25 and OfficeState.insanity < 50:
			pulsing.play("Beat1")
		if OfficeState.insanity >= 50 and OfficeState.insanity < 75:
			pulsing.play("Beat2")
		elif OfficeState.insanity >= 75:
			pulsing.play("Beat3")
	else:
		pulsing.stop()
	
	
func _on_ambience_timer_timeout():
	var play = randi_range(1,play_chance)
	if play == 1:
		get_node("Ambience" + str(randi_range(1,6))).play()
		print("-- Ambience Played --")
		play_chance = 4
	else:
		play_chance -= 1
	$AmbienceTimer.wait_time = randi_range(45,90)
	$AmbienceTimer.start()
	
func mute_background():
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Reverb SFX"), true)
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Office SFX"), true)
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Local SFX + Reverb"), true)
	
func load_static():
	OfficeState.dead = true
	static_anim.play("JumpscareTransition")

func load_night5_end():
	save.CheckNight()
	OfficeState.dead = true
	static_anim.play("Night5End")

func _on_hour_timer_timeout():
	if !OfficeState.dead and !OfficeState.hour == 6:
		OfficeState.hour += 1
		if OfficeState.hour >= 6:
			if OfficeState.night_number == 5 and !night_5_end:
				night_5_end = true
				$PhoneGuy.play("PhoneCall_5End")
			else:
				win_anim.play("6AM")
				save.CheckNight()
		clock.update_hour()
		InterfaceMonitor.update_hour()
		
func ur_fucked():
	$"../Bonnie".base_agression = 0
	$"../Chica".base_agression = 0
	$"../Freddy".base_agression = 0
	$"../Endo".base_agression = 0
	$"../Foxy".base_agression = 0
	OfficeState.power_left = 0
	
func next_night():
	get_tree().quit()

func game_over_screen():
	game_over = true
