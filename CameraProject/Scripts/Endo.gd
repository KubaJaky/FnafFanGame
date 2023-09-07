extends StaticBody3D

@onready var move_cd = $MoveCD
@onready var attack_cd = $AttackCD
@onready var move_wait = $MoveWait
@onready var return_wait = $ReturnWait

@onready var player = $"../UI"
@onready var player_cam_anim = $"../Player/Camera3D/PlayerCamAnim"
@onready var fusebox_anim = $"../FuseBox/OpenClose"

@onready var cam_monitor = $"../Monitor1"
@onready var body = $EndoModel
#@onready var body = $Body
@onready var animation_player = $EndoModel/AnimationPlayer
@onready var state_anim = $StateAnim
@onready var door_anim = $"../Endo/DoorAnim"

@onready var position_names := ["Phase1", "Phase2", "Phase3"]
@onready var endo_positions = $"../EndoPositions"
@onready var positions = endo_positions.get_children()

@onready var endo_noise = $EndoNoise

var CurrentPosition = 0

var was_seen := false
var ready_to_attack := false
var make_noise := false

var agression = 10 #10
var base_agression = agression

var insanity_inrease = 1

func _physics_process(delta):	
	if !OfficeState.in_jumpscare and !OfficeState.dead and !OfficeState.hour >= 6:
		if OfficeState.hour < 2:
			agression = base_agression - (10 + OfficeState.night_number)
		elif agression != base_agression:
			agression = base_agression
			
		if ready_to_attack:
			if OfficeState.left_door_closed and !attack_cd.paused:
				attack_cd.set_paused(true)
				return_wait.set_paused(false)
				print(return_wait.paused, " - ", return_wait.time_left)
			elif !OfficeState.left_door_closed and attack_cd.paused:
				attack_cd.set_paused(false)
				return_wait.set_paused(true)
				print(return_wait.paused, " - ", return_wait.time_left)
				
		if CurrentPosition == positions.size() - 1:
			if OfficeState.flashlight_on and OfficeState.looking_left:
				body.visible = true
				if !OfficeState.left_door_closed:
					if !was_seen:
						OfficeState.insanity += insanity_inrease * 10
						was_seen = true
						player.stinger_sound.play()
					else:
						OfficeState.insanity += insanity_inrease
			else:
				body.visible = false


func _on_move_cd_timeout():
	if !OfficeState.in_jumpscare and !OfficeState.dead and !OfficeState.hour >= 6:
		#print("Endo - Movement Opportunity")
		var move_chance = randi_range(1,20)
		if agression >= move_chance:
			if CurrentPosition == positions.size() - 2 and OfficeState.looking_left == true or CurrentPosition == positions.size() - 2 and OfficeState.left_door_occupied == true:
				print("Endo - Blocked")
				print("Endo - Looking at door - ", CurrentPosition == positions.size() - 2 and OfficeState.looking_left == true)
				print("Endo - Door Occupied - ", CurrentPosition == positions.size() - 2 and OfficeState.left_door_occupied == true)
			else:
				CurrentPosition += 1
				move_wait.start()
				print("Endo - ",CurrentPosition, " / ", positions.size() - 1)
		
func _on_move_wait_timeout():
	if !OfficeState.in_jumpscare and !OfficeState.dead and !OfficeState.hour >= 6:
		move()
		
func move():
	print("Endo - Moved")
	if CurrentPosition == positions.size() - 1:
			move_cd.stop()
			ready_to_attack = true
			OfficeState.left_door_occupied = true
			attack_cd.start()
			attack_cd.set_paused(false)
			return_wait.start()
			return_wait.set_paused(true)
			make_noise = true
			state_anim.play("DoorState")
	global_position = positions[CurrentPosition].global_position
	rotation = positions[CurrentPosition].rotation
	animation_player.play(position_names[CurrentPosition])
	if CurrentPosition == 1:
		door_anim.play("DoorOpen")
		
func noise():
	if make_noise == true:
		if !OfficeState.in_jumpscare and !OfficeState.dead and !OfficeState.hour >= 6:
			state_anim.play("DoorState")
			endo_noise.pitch_scale += 0.1
	
func jumpscare():
	if !OfficeState.in_jumpscare and !OfficeState.dead and !OfficeState.hour >= 6:
		global_position = player_cam_anim.get_parent().get_parent().get_node("JumpscarePosLeft").global_position
		if OfficeState.in_cameras:
			OfficeState.in_cameras = false
			player_cam_anim.speed_scale = 2
			player_cam_anim.play_backwards("Zoom")
		if OfficeState.in_fusebox:
			OfficeState.in_fusebox = false
			fusebox_anim.speed_scale = 2
			fusebox_anim.play_backwards("OpenClose")
		if OfficeState.eyes_closed:
			player.eyes_anim.play_backwards("CloseEyes")
		player.CameraRotation = 90.1
		print("Endo - Dead")
		OfficeState.in_jumpscare = true
		body.visible = true
		animation_player.speed_scale = 1
		state_anim.speed_scale = 1
		animation_player.play("Jumpscare")
		state_anim.play("JumpscareState")
		
func jumpscare_sound():
	player.jumpscare_sound.play()
		
func end_jumpscare():
	if !OfficeState.hour >= 6:
		player.load_static()

func _on_attack_cd_timeout():
	jumpscare()

func _on_return_wait_timeout():
	print("Endo - Reset")
	attack_cd.stop()
	ready_to_attack = false
	OfficeState.left_door_occupied = false
	CurrentPosition = 0
	was_seen = false
	make_noise = false
	endo_noise.pitch_scale = 0.7
	move_wait.start()
	door_anim.play("RESET")
	move_cd.start()
