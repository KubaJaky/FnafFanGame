extends StaticBody3D

@onready var move_cd = $MoveCD
@onready var attack_cd = $AttackCD
@onready var move_wait = $MoveWait
@onready var return_wait = $ReturnWait

@onready var player = $"../UI"
@onready var player_cam_anim = $"../Player/Camera3D/PlayerCamAnim"
@onready var fusebox_anim = $"../FuseBox/OpenClose"

@onready var cam_monitor = $"../Monitor1"
@onready var body = $BonnieModel
#@onready var body = $Body
@onready var guitar = $BonnieModel/Armature/Skeleton3D/Cube009/Cube009
@onready var animation_player = $BonnieModel/AnimationPlayer
@onready var state_anim = $StateAnim

@onready var pos_pupil_l = $BonnieModel/Armature/Skeleton3D/Icosphere032/Icosphere032/PupilL
@onready var pos_pupil_r = $BonnieModel/Armature/Skeleton3D/Icosphere020/Icosphere020/PupilR
@onready var pupil_l = $PupilL
@onready var pupil_r = $PupilR


@onready var position_names := ["Stage","DiningArea","Backstage","Arcade","WHall","LDoor1"]
@onready var bonnie_positions = $"../BonniePositions"
@onready var positions = bonnie_positions.get_children()

var PositionCameras = [0,1,2,3,7]
var CurrentPosition = 0

var was_seen := false
var ready_to_attack := false

@export var agression :int #12 - night 3
var base_agression :int
	
var insanity_inrease = 0.5

func _ready():
	base_agression = agression

func _physics_process(delta):
	if !OfficeState.in_jumpscare and !OfficeState.dead and !OfficeState.hour >= 6:
		if OfficeState.hour < 1:
			agression = base_agression - (5 + OfficeState.night_number)
		elif agression != base_agression:
			agression = base_agression
			
		if ready_to_attack:
			if OfficeState.left_door_closed and !attack_cd.paused:
				attack_cd.set_paused(true)
				return_wait.set_paused(false)
			elif !OfficeState.left_door_closed and attack_cd.paused:
				attack_cd.set_paused(false)
				return_wait.set_paused(true)
				
		if CurrentPosition == positions.size() - 1:
			if attack_cd.time_left > 0 and !OfficeState.in_jumpscare:
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
				
	pupil_l.global_position = pos_pupil_l.global_position
	pupil_r.global_position = pos_pupil_r.global_position

func _on_move_cd_timeout():
	if !OfficeState.in_jumpscare and !OfficeState.dead and !OfficeState.hour >= 6:
		#print("Bonnie - Movement Opportunity")
		var move_chance = randi_range(1,20)
		if agression >= move_chance:
			if CurrentPosition == positions.size() - 2 and OfficeState.looking_left == true or CurrentPosition == positions.size() - 2 and OfficeState.left_door_occupied == true:
				print("Bonnie - Blocked")
				print("Bonnie - Looking at door - ", CurrentPosition == positions.size() - 2 and OfficeState.looking_left == true)
				print("Bonnie - Door Occupied - ", CurrentPosition == positions.size() - 2 and OfficeState.left_door_occupied == true)
			else:
				var choose_room
				if CurrentPosition == 1:
					choose_room = randi_range(1,2)
				elif CurrentPosition == 2:
					choose_room = randi_range(-1, 1)
					if choose_room == 0:
						choose_room = -1
				else:
					choose_room = 1
				disrupt_camera(choose_room)
				CurrentPosition += choose_room
				move_wait.start()
				print("Bonnie - ",CurrentPosition, " / ", positions.size() - 1)
		
func _on_move_wait_timeout():
	if !OfficeState.in_jumpscare and !OfficeState.dead and !OfficeState.hour >= 6:
		move()
		
func move():
		print("Bonnie - Moved")
		if CurrentPosition == positions.size() - 1:
				move_cd.stop()
				OfficeState.left_door_occupied = true
				ready_to_attack = true
				attack_cd.start()
				attack_cd.set_paused(false)
				return_wait.start()
				return_wait.set_paused(true)
		if CurrentPosition != 0 and guitar.visible:
			guitar.visible = false
		global_position = positions[CurrentPosition].global_position
		rotation = positions[CurrentPosition].rotation
		animation_player.play(position_names[CurrentPosition])
	
func disrupt_camera(room_move):
	if OfficeState.in_cameras:
		if CurrentPosition == PositionCameras.size() - 1:
			if OfficeState.CurrentCamera == PositionCameras[CurrentPosition]:
				cam_monitor.lose_signal()
		else:
			if OfficeState.CurrentCamera == PositionCameras[CurrentPosition] or OfficeState.CurrentCamera == PositionCameras[CurrentPosition + room_move]:
				cam_monitor.lose_signal()
	
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
		print("Bonnie - Dead")
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
	print("Bonnie - Reset")
	attack_cd.stop()
	ready_to_attack = false
	OfficeState.left_door_occupied = false
	body.visible = true
	CurrentPosition = 1
	was_seen = false
	move_wait.start()
	disrupt_camera(0)
	move_cd.start()
